import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/garden_plant.dart';
import '../models/garden_task.dart';
import '../models/plant.dart';
import '../utils/climate_zones.dart';
import 'garden_service.dart';
import 'monthly_chores_service.dart';
import 'plant_database_service.dart';

/// Generates the user's "Att göra"-list from current garden state and
/// applies persisted user state (completed/snoozed) on top. The list is
/// always derived — only the user's *interactions* are persisted, so
/// adding a plant immediately produces tasks and removing it makes
/// them disappear without any sync logic.
///
/// Generation sources, in priority order:
///   1. **Watering** — based on `plant.vattning` cadence + lastWatered
///   2. **Harvest** — when plant is in active harvest window AND mature
///   3. **Care tasks** — `plant.omsorg` entries for current/next month
///   4. **Lifecycle phases** — sow/harden/plant-out reminders that the
///      old notification system fired (now persistent tasks)
///   5. **Monthly chores** — generic gardening sysslor for the month
///
/// The result is bucketed by due-date relative to today (today / this
/// week / this month / later) for the UI.
class TaskService extends ChangeNotifier {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  static const _dbName = 'plantera.db';
  static const _completionsTable = 'task_completions';
  static const _snoozesTable = 'task_snoozes';

  final GardenService _garden = GardenService();
  final PlantDatabaseService _plantDb = PlantDatabaseService();
  final MonthlyChoresService _chores = MonthlyChoresService();

  Database? _db;
  Map<String, DateTime> _completed = {};
  Map<String, DateTime> _snoozed = {};
  List<GardenTask> _cache = const [];
  bool _wired = false;

  List<GardenTask> get tasks => List.unmodifiable(_cache);

  /// Tasks whose dueDate is on or before [today]. Already-completed
  /// tasks are excluded. Snoozed tasks reappear when their snooze
  /// expires.
  List<GardenTask> tasksDueBy(DateTime today) =>
      _cache.where((t) => t.isDueOnOrBefore(today)).toList();

  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(dbPath);
    // Tables are created by GardenService's onCreate/onUpgrade — defensive
    // CREATE IF NOT EXISTS in case the user is on a partial-migration state.
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS $_completionsTable (
        task_key TEXT PRIMARY KEY,
        completed_at INTEGER NOT NULL
      )
    ''');
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS $_snoozesTable (
        task_key TEXT PRIMARY KEY,
        snoozed_until INTEGER NOT NULL
      )
    ''');
    await _loadState();
    if (!_wired) {
      // Regenerate when garden changes (plants added/removed/watered).
      _garden.addListener(_regenerate);
      _wired = true;
    }
    _regenerate();
  }

  Future<void> _loadState() async {
    if (_db == null) return;
    // Prune ancient completions before loading. Completions accrue one row
    // per plant per watering day and are fully loaded each launch, so they
    // grow unbounded over a season. A completion only matters while its
    // "Klart idag"-row is visible (same calendar day), so anything older
    // than 60 days is dead weight. Snoozes self-expire and delete-cleanup
    // already bounds the others — only completions leak.
    final cutoff = DateTime.now()
        .subtract(const Duration(days: 60))
        .millisecondsSinceEpoch;
    await _db!.delete(_completionsTable,
        where: 'completed_at < ?', whereArgs: [cutoff]);
    final results = await Future.wait([
      _db!.query(_completionsTable),
      _db!.query(_snoozesTable),
    ]);
    _completed = {
      for (final r in results[0])
        r['task_key'] as String:
            DateTime.fromMillisecondsSinceEpoch(r['completed_at'] as int)
    };
    _snoozed = {
      for (final r in results[1])
        r['task_key'] as String:
            DateTime.fromMillisecondsSinceEpoch(r['snoozed_until'] as int)
    };
  }

  /// Mark a task done. Idempotent — re-completing the same key just
  /// updates the timestamp. Done tasks vanish from the active list and
  /// reappear in "Klart idag" until midnight.
  Future<void> complete(GardenTask t) async {
    if (_db == null) return;
    final now = DateTime.now();
    // Water-task keys encode the rotating daily due-date, so a completion
    // logged under the raw key would never match the task regenerated
    // tomorrow (new date → new key) and the "Klart idag"-row would vanish.
    // Key the completion on the date-less snoozeIdentity for water so the
    // join survives the daily regenerate cycle. Other kinds already encode
    // only the year in their key, so the raw key is stable enough.
    final completionKey = t.snoozeIdentity;
    // DB first so a write failure can't leave the in-memory cache
    // claiming a task is done when nothing is persisted. The next
    // _regenerate would happily re-emit the task and the user would
    // think it stuck — but a relaunch would resurrect it.
    await _db!.insert(
      _completionsTable,
      {'task_key': completionKey, 'completed_at': now.millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _completed[completionKey] = now;
    // Clear any matching snooze — completing a task supersedes a pending
    // snooze. Without this a stale water snooze keeps hiding the next
    // preview task for ~a day after the user has already watered.
    final snoozeId = t.snoozeIdentity;
    if (_snoozed.containsKey(snoozeId)) {
      await _db!.delete(_snoozesTable,
          where: 'task_key = ?', whereArgs: [snoozeId]);
      _snoozed.remove(snoozeId);
    }
    // Side effects per kind:
    //   water → bump GardenPlant.lastWatered so the next-water-due math
    //   uses the correct anchor.
    if (t.kind == TaskKind.water && t.gardenPlantId != null) {
      await _garden.markWatered(t.gardenPlantId!);
      // markWatered notifies, which triggers _regenerate via listener.
    } else {
      _regenerate();
    }
  }

  /// Push the task forward by [days] days (default 1). The same task
  /// won't reappear in the active list until then.
  ///
  /// Stores the snooze under [GardenTask.snoozeIdentity] (NOT the raw
  /// key) so water tasks — whose keys encode the daily due-date and
  /// thus mutate every day — survive past tomorrow's regenerate cycle.
  Future<void> snooze(GardenTask t, {int days = 1}) async {
    if (_db == null) return;
    final until = DateTime.now().add(Duration(days: days));
    final id = t.snoozeIdentity;
    await _db!.insert(
      _snoozesTable,
      {'task_key': id, 'snoozed_until': until.millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _snoozed[id] = until;
    _regenerate();
  }

  /// Reverse a [snooze] — drops the snooze row so the task reappears in
  /// the active list immediately. Backs the "Ångra"-action on the
  /// swipe-snooze SnackBar. Snoozes are cleanly reversible (unlike a
  /// water completion, which also bumps lastWatered), so only this undo
  /// is offered.
  Future<void> undoSnooze(GardenTask t) async {
    if (_db == null) return;
    final id = t.snoozeIdentity;
    await _db!.delete(_snoozesTable, where: 'task_key = ?', whereArgs: [id]);
    _snoozed.remove(id);
    _regenerate();
  }

  /// Force a regenerate. Cheap — under a few hundred plants this is
  /// sub-millisecond.
  void refresh() => _regenerate();

  void _regenerate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAhead = today.add(const Duration(days: 7));
    final monthAhead = today.add(const Duration(days: 30));

    final tasks = <GardenTask>[];
    final activeId = _garden.activeGardenId;
    final scopedPlants = activeId == null
        ? _garden.allPlants
        : _garden.allPlants.where((g) => g.gardenId == activeId).toList();

    for (final gp in scopedPlants) {
      final plant = _plantDb.byId(gp.plantId);
      if (plant == null) continue;
      tasks.addAll(_waterTasksFor(gp, plant, today));
      tasks.addAll(_harvestTasksFor(gp, plant, today, monthAhead));
      tasks.addAll(_careTasksFor(gp, plant, today, monthAhead));
      tasks.addAll(_lifecycleTasksFor(gp, plant, today, monthAhead));
    }

    // Generic chores — applies to whole garden, not per-plant. Filter
    // by what the user actually grows: "Gallra äpple och plommon" only
    // shows up if there's an äpple or plommon in the active garden.
    if (scopedPlants.isNotEmpty) {
      final activePlantIds =
          scopedPlants.map((gp) => gp.plantId).toSet();
      final activeCategories = <String>{};
      for (final gp in scopedPlants) {
        final plant = _plantDb.byId(gp.plantId);
        if (plant != null) activeCategories.add(plant.kategori.name);
      }
      tasks.addAll(_choreTasksFor(
        today,
        weekAhead,
        userPlantIds: activePlantIds,
        userCategories: activeCategories,
      ));
    }

    // Apply user state, drop completed, and sort by due date + priority.
    final filtered = <GardenTask>[];
    for (final t in tasks) {
      // Match completions on the same identity complete() writes under —
      // snoozeIdentity folds the rotating daily date out of water keys so
      // a completed/snoozed water task still resolves to its "done" row.
      final doneAt = _completed[t.snoozeIdentity];
      if (doneAt != null) {
        // Keep done items visible until end of today (calendar day) so the
        // user sees what they accomplished. Comparing on the calendar day
        // — not a raw 6h window — stops yesterday-evening completions from
        // lingering into the next morning's list.
        final doneDay = DateTime(doneAt.year, doneAt.month, doneAt.day);
        if (!doneDay.isBefore(today)) {
          filtered.add(t.withStatus(
              status: TaskStatus.done, completedAt: doneAt));
        }
        continue;
      }
      final snoozedUntil = _snoozed[t.snoozeIdentity];
      if (snoozedUntil != null && snoozedUntil.isAfter(now)) {
        continue; // hide from active list while snoozed
      }
      filtered.add(t);
    }

    filtered.sort((a, b) {
      // Pending first; done sinks to bottom.
      final aActive = a.status == TaskStatus.pending ? 0 : 1;
      final bActive = b.status == TaskStatus.pending ? 0 : 1;
      if (aActive != bActive) return aActive - bActive;
      // Then by due-date, earliest first.
      final dueCmp = a.dueDate.compareTo(b.dueDate);
      if (dueCmp != 0) return dueCmp;
      // Then by priority, urgent first.
      return b.priority.index.compareTo(a.priority.index);
    });

    _cache = filtered;
    notifyListeners();
  }

  // ── Generators ─────────────────────────────────────────────────────

  /// Watering: outdoor plants that haven't been watered within their
  /// cadence. Skips planerad (not in the ground yet) and skordad
  /// (season's done).
  ///
  /// Cadence is season-scaled for OUTDOOR plants — winter rain handles
  /// 90% of watering for plants that are "Står ute" or "Direktsådd ute",
  /// and over-watering in dormancy is the #1 way hobbyists kill plants.
  /// Indoor seedlings (forsoddInne) keep their year-round cadence.
  Iterable<GardenTask> _waterTasksFor(
      GardenPlant gp, Plant plant, DateTime today) sync* {
    if (gp.status == PlantStatus.planerad ||
        gp.status == PlantStatus.skordad ||
        gp.status == PlantStatus.vilande) {
      return;
    }
    final baseDays = switch (plant.vattning) {
      WaterNeed.sparsam => 7,
      WaterNeed.regelbunden => 3,
      WaterNeed.riklig => 2,
    };
    final cadenceDays = (baseDays * _seasonalWaterFactor(today, gp.status))
        .round()
        .clamp(1, 21);
    final last = gp.lastWatered;
    final nextDue = last == null
        ? today
        : DateTime(last.year, last.month, last.day)
            .add(Duration(days: cadenceDays));
    final dateStr = DateFormat('yyyy-MM-dd').format(nextDue);
    final key = 'water-${gp.id}-$dateStr';
    final isOverdue =
        last != null && today.difference(last).inDays > cadenceDays + 2;
    yield GardenTask(
      key: key,
      kind: TaskKind.water,
      title: 'Vattna ${(gp.customName ?? plant.namnSv).toLowerCase()}',
      body: last == null
          ? 'Aldrig registrerad vattning'
          : '${today.difference(last).inDays} dgr sedan senaste',
      emoji: '💧',
      dueDate: nextDue,
      priority: isOverdue ? TaskPriority.high : TaskPriority.normal,
      gardenPlantId: gp.id,
      gardenId: gp.gardenId,
    );
  }

  /// Multiplier on the base water cadence based on season + status.
  ///
  /// Hobbyists with outdoor plants in November–February kill them by
  /// over-watering (rain handles 90% of what an outdoor garden needs,
  /// dormant root systems can't process more). Indoor seedlings keep
  /// their year-round cadence because kitchen heating dries fast.
  ///
  /// Numbers are intentionally conservative — even at 3× the worst-case
  /// is "plant is a bit dry for a day", far better than root rot.
  double _seasonalWaterFactor(DateTime today, PlantStatus status) {
    // Indoor seedlings or no-status: full cadence year-round.
    // 'hardad' (härdar av) seedlings are only out for part of the day and
    // still in pots — the most drought-sensitive stage. Treating them as
    // fully outdoor stretched their watering 1.5-2x in a cold spring, so
    // they keep the indoor (1.0) cadence.
    final isOutdoor = status == PlantStatus.direktsadd ||
        status == PlantStatus.utplanterad ||
        status == PlantStatus.skordeklar;
    if (!isOutdoor) return 1.0;
    // Pure Swedish/Northern hemisphere bias for v1 — Plantera's
    // ASC listing is sv-only so the user base is northern.
    final month = today.month;
    if (month == 12 || month == 1 || month == 2) return 3.0; // winter
    if (month == 11 || month == 3) return 2.0; // shoulder cold
    if (month == 10 || month == 4) return 1.5; // shoulder mild
    return 1.0; // May-Sep peak growing season
  }

  /// Harvest / bloom: plant has matured AND is in active period.
  ///
  /// For edible crops (vegetables, herbs, berries, fruit trees) we emit
  /// a harvest task — the user grows them to pick. For ornamental
  /// flowers we instead emit a *bloom* task, since "Skörda ros" feels
  /// wrong when the user is growing roses for beauty, not cuttings.
  Iterable<GardenTask> _harvestTasksFor(
      GardenPlant gp, Plant plant, DateTime today, DateTime horizon) sync* {
    if (plant.skordeperiod == null) return;
    if (gp.status == PlantStatus.planerad ||
        gp.status == PlantStatus.forsoddInne ||
        gp.status == PlantStatus.skordad ||
        gp.status == PlantStatus.vilande) {
      // A dormant plant isn't producing — no harvest or bloom even if the
      // calendar month falls inside its skordeperiod (watering already
      // skips vilande for the same reason).
      return;
    }
    // Map today's calendar month into NH-equivalent terms for the
    // SH-aware harvest-window check. NH users get an identity shift.
    final activeGarden = _garden.activeGarden;
    final hemi = (activeGarden?.lat != null)
        ? Hemisphere.forLatitude(activeGarden!.lat!)
        : Hemisphere.north;
    final lookupMonth = hemi.shiftMonth(today.month);
    final inWindowNow = plant.skordeperiod!.includes(lookupMonth);
    if (!inWindowNow) return;

    final isLongLived = plant.livscykel == PlantLifecycle.perennial ||
        plant.livscykel == PlantLifecycle.tree ||
        plant.livscykel == PlantLifecycle.shrub;

    final maturityOk = isLongLived ||
        gp.status == PlantStatus.skordeklar ||
        _annualHasMatured(plant, gp, today);
    if (!maturityOk) return;

    final isFlower = plant.kategori == PlantCategory.blommor;
    final displayName = (gp.customName ?? plant.namnSv).toLowerCase();

    if (isFlower) {
      // Bloom reminder — informational, lower priority. User grows
      // ornamentals to look at, not to pick.
      yield GardenTask(
        key: 'bloom-${gp.id}-${today.year}',
        kind: TaskKind.bloom,
        title: 'Blomning: $displayName',
        body: 'Njut — blomningen pågår. Klipp för vas om du vill.',
        emoji: plant.emoji,
        dueDate: today,
        priority: TaskPriority.normal,
        gardenPlantId: gp.id,
        gardenId: gp.gardenId,
      );
      return;
    }

    // Edible crop — actual harvest task.
    yield GardenTask(
      key: 'harvest-${gp.id}-${today.year}',
      kind: TaskKind.harvest,
      title: 'Skörda $displayName',
      body: gp.status == PlantStatus.skordeklar
          ? 'Markerad som skördeklar'
          : 'Skördeperioden är aktiv',
      emoji: plant.emoji,
      dueDate: today,
      priority: TaskPriority.high,
      gardenPlantId: gp.id,
      gardenId: gp.gardenId,
    );
  }

  bool _annualHasMatured(Plant plant, GardenPlant gp, DateTime today) {
    final dtH = plant.dagarTillSkord;
    final plantedDay =
        DateTime(gp.plantedDate.year, gp.plantedDate.month, gp.plantedDate.day);
    final daysGrown = today.difference(plantedDay).inDays;
    if (dtH != null) {
      // 80% of days-to-harvest is when an annual is *expected* to be
      // mature. The user's own per-plant `harvestOffsetDays` lets them
      // push earlier ("my zone runs warmer") or later ("had a cold
      // spring"). Previously this field was stored but never read —
      // an inert tweak setting. Now it actually moves the maturity
      // threshold.
      final base = (dtH * 0.8).round();
      return daysGrown >= base + gp.harvestOffsetDays;
    }
    return daysGrown >= 30 + gp.harvestOffsetDays;
  }

  /// Per-plant care tasks from `plant.omsorg`. Generated when the
  /// task's month range starts within the next 30 days.
  Iterable<GardenTask> _careTasksFor(
      GardenPlant gp, Plant plant, DateTime today, DateTime horizon) sync* {
    for (final care in plant.omsorg) {
      // Determine *this year's* due date for the task. If we're already
      // past it, jump to next year (bucketed in key so we don't conflate).
      var due = DateTime(today.year, care.month.startMonth, 1);
      if (due.isBefore(today.subtract(const Duration(days: 7)))) {
        due = DateTime(today.year + 1, care.month.startMonth, 1);
      }
      if (due.isAfter(horizon)) continue;
      final key = 'care-${gp.id}-${care.id}-${due.year}';
      // Map known omsorg-titles to specific kinds for accent color.
      final kind = _careKindFromTitle(care.title);
      yield GardenTask(
        key: key,
        kind: kind,
        title:
            '${care.title} – ${(gp.customName ?? plant.namnSv).toLowerCase()}',
        body: care.description,
        emoji: plant.emoji,
        dueDate: due,
        priority: care.severity == 'high'
            ? TaskPriority.high
            : TaskPriority.normal,
        gardenPlantId: gp.id,
        gardenId: gp.gardenId,
      );
    }
  }

  TaskKind _careKindFromTitle(String title) {
    final l = title.toLowerCase();
    if (l.contains('beskär') || l.contains('klipp')) return TaskKind.prune;
    if (l.contains('gödsl')) return TaskKind.fertilize;
    if (l.contains('skörd')) return TaskKind.harvest;
    return TaskKind.careTask;
  }

  /// Lifecycle-phase tasks (sow → harden → plant-out). These are the
  /// things the old fire-and-forget notifications did, now expressed
  /// as persistent tasks.
  Iterable<GardenTask> _lifecycleTasksFor(
      GardenPlant gp, Plant plant, DateTime today, DateTime horizon) sync* {
    final emoji = plant.emoji;
    final name = (gp.customName ?? plant.namnSv).toLowerCase();

    if (gp.status == PlantStatus.planerad) {
      switch (gp.sowingMethod) {
        case SowingMethod.inomhus:
          if (plant.forsadatum != null) {
            yield* _phaseTask(
              key: 'sow-indoor-${gp.id}-${today.year}',
              kind: TaskKind.sow,
              title: 'Förodla $name inomhus',
              body: 'Sånings-fönstret öppnar',
              emoji: emoji,
              monthStart: plant.forsadatum!.startMonth,
              today: today,
              horizon: horizon,
              gp: gp,
            );
          }
        case SowingMethod.direkt:
          if (plant.direktsadatum != null) {
            yield* _phaseTask(
              key: 'sow-direct-${gp.id}-${today.year}',
              kind: TaskKind.sow,
              title: 'Direktså $name ute',
              body: 'Sånings-fönstret öppnar',
              emoji: emoji,
              monthStart: plant.direktsadatum!.startMonth,
              today: today,
              horizon: horizon,
              gp: gp,
            );
          }
        case SowingMethod.planta:
          if (plant.utplanteringsdatum != null) {
            yield* _phaseTask(
              key: 'plant-out-${gp.id}-${today.year}',
              kind: TaskKind.plantOut,
              title: 'Plantera ut $name',
              body: 'Utplanterings-fönstret öppnar',
              emoji: emoji,
              monthStart: plant.utplanteringsdatum!.startMonth,
              today: today,
              horizon: horizon,
              gp: gp,
            );
          }
      }
    } else if (gp.status == PlantStatus.forsoddInne) {
      // Harden off after ~35 days indoors.
      final hardenAt =
          gp.plantedDate.add(const Duration(days: 35));
      if (!hardenAt.isAfter(horizon) && !hardenAt.isBefore(today)) {
        final key = 'harden-${gp.id}-${today.year}';
        yield GardenTask(
          key: key,
          kind: TaskKind.hardenOff,
          title: 'Härda av $name',
          body: 'Ställ ut plantorna en vecka innan utplantering',
          emoji: emoji,
          dueDate: hardenAt,
          gardenPlantId: gp.id,
          gardenId: gp.gardenId,
        );
      }
      if (plant.utplanteringsdatum != null) {
        yield* _phaseTask(
          key: 'plant-out-${gp.id}-${today.year}',
          kind: TaskKind.plantOut,
          title: 'Plantera ut $name',
          body: 'Utplanterings-fönstret öppnar',
          emoji: emoji,
          monthStart: plant.utplanteringsdatum!.startMonth,
          today: today,
          horizon: horizon,
          gp: gp,
        );
      }
    }
  }

  Iterable<GardenTask> _phaseTask({
    required String key,
    required TaskKind kind,
    required String title,
    required String body,
    required String emoji,
    required int monthStart,
    required DateTime today,
    required DateTime horizon,
    required GardenPlant gp,
  }) sync* {
    // This year's window start. If we're more than 14d past it the window
    // for *this* year has opened already — the previously-fired "förodla i
    // mars"-task shouldn't keep sitting at the top of the list in May, so
    // we bump to next year's occurrence.
    var due = DateTime(today.year, monthStart, 1);
    final thisYearStart = due;
    final wrapped = due.isBefore(today.subtract(const Duration(days: 14)));
    if (wrapped) {
      due = DateTime(today.year + 1, monthStart, 1);
    }
    // Horizon kill: anything opening beyond the 30-day horizon is too far
    // off to surface yet. (Previously this was gated on `due.year >
    // today.year`, which let every later-this-year window — August sow,
    // plant-out — leak into May/June, AND made the autumn-bulb branch
    // below unreachable. Both are fixed by dropping that condition.)
    if (due.isAfter(horizon)) {
      // Year-wrap exception for autumn-sow crops (höstvitlök forsådatum
      // okt-nov, skörd next år): when this year's window opened in the
      // last ~6 weeks we're still inside the planting season, so keep
      // showing the task anchored to this year's start rather than hiding
      // it until next autumn. Only the genuinely-stale wrap (window long
      // past, next occurrence far off) is suppressed.
      final inAutumnSeason = wrapped &&
          thisYearStart.isAfter(today.subtract(const Duration(days: 45)));
      if (inAutumnSeason) {
        due = thisYearStart;
      } else {
        return;
      }
    }
    yield GardenTask(
      key: key,
      kind: kind,
      title: title,
      body: body,
      emoji: emoji,
      dueDate: due,
      gardenPlantId: gp.id,
      gardenId: gp.gardenId,
    );
  }

  /// Generic monthly chores — applies to the whole garden, filtered
  /// against the user's actual plants. A chore with `applies_to_plants`
  /// or `applies_to_categories` set only shows up when the user has at
  /// least one matching plant. Universal chores (no filter) always show.
  Iterable<GardenTask> _choreTasksFor(
    DateTime today,
    DateTime weekAhead, {
    required Set<String> userPlantIds,
    required Set<String> userCategories,
  }) sync* {
    final upcoming = _chores.upcoming(now: today);
    for (final c in upcoming) {
      if (!c.isUniversal) {
        final matchesPlant = c.appliesToPlants.any(userPlantIds.contains);
        final matchesCategory =
            c.appliesToCategories.any(userCategories.contains);
        if (!matchesPlant && !matchesCategory) continue;
      }
      // Bucket per (chore, year, month) so completing it once silences
      // it for the rest of the month. Avoid scheduling on the 1st of
      // the current month when we're past the 1st — that puts the
      // chore "in the past" which sorts it to the top forever. Use
      // today instead so it joins the natural sort order.
      final dueMonth = c.month;
      final dueYear =
          (dueMonth >= today.month) ? today.year : today.year + 1;
      final due = (dueYear == today.year && dueMonth == today.month)
          ? today
          : DateTime(dueYear, dueMonth, 1);
      final key = 'chore-${c.id}-$dueYear';
      yield GardenTask(
        key: key,
        kind: TaskKind.monthlyChore,
        title: c.title,
        body: c.description,
        emoji: c.emoji,
        dueDate: due,
        // No gardenPlantId — generic chore.
      );
    }
  }
}
