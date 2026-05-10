import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/garden_plant.dart';
import '../models/garden_task.dart';
import '../models/plant.dart';
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
    _completed[t.key] = now;
    await _db!.insert(
      _completionsTable,
      {'task_key': t.key, 'completed_at': now.millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
  Future<void> snooze(GardenTask t, {int days = 1}) async {
    if (_db == null) return;
    final until = DateTime.now().add(Duration(days: days));
    _snoozed[t.key] = until;
    await _db!.insert(
      _snoozesTable,
      {'task_key': t.key, 'snoozed_until': until.millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

    // Generic chores — applies to whole garden, not per-plant.
    if (scopedPlants.isNotEmpty) {
      tasks.addAll(_choreTasksFor(today, weekAhead));
    }

    // Apply user state, drop completed, and sort by due date + priority.
    final filtered = <GardenTask>[];
    for (final t in tasks) {
      final doneAt = _completed[t.key];
      if (doneAt != null) {
        // Keep done items visible until midnight tomorrow so the user
        // can see what they accomplished today.
        if (doneAt.isAfter(today.subtract(const Duration(hours: 6)))) {
          filtered.add(t.withStatus(
              status: TaskStatus.done, completedAt: doneAt));
        }
        continue;
      }
      final snoozedUntil = _snoozed[t.key];
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
  Iterable<GardenTask> _waterTasksFor(
      GardenPlant gp, Plant plant, DateTime today) sync* {
    if (gp.status == PlantStatus.planerad ||
        gp.status == PlantStatus.skordad ||
        gp.status == PlantStatus.vilande) {
      return;
    }
    final cadenceDays = switch (plant.vattning) {
      WaterNeed.sparsam => 7,
      WaterNeed.regelbunden => 3,
      WaterNeed.riklig => 2,
    };
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

  /// Harvest: plant has matured AND is in active harvest period.
  Iterable<GardenTask> _harvestTasksFor(
      GardenPlant gp, Plant plant, DateTime today, DateTime horizon) sync* {
    if (plant.skordeperiod == null) return;
    if (gp.status == PlantStatus.planerad ||
        gp.status == PlantStatus.forsoddInne ||
        gp.status == PlantStatus.skordad) {
      return;
    }
    final inHarvestNow = plant.skordeperiod!.includes(today.month);
    if (!inHarvestNow) return;

    final isLongLived = plant.livscykel == PlantLifecycle.perennial ||
        plant.livscykel == PlantLifecycle.tree ||
        plant.livscykel == PlantLifecycle.shrub;

    final maturityOk = isLongLived ||
        gp.status == PlantStatus.skordeklar ||
        _annualHasMatured(plant, gp, today);
    if (!maturityOk) return;

    // Bucket by year so the task is "this year's harvest" and the user
    // can complete it once per season.
    final key = 'harvest-${gp.id}-${today.year}';
    yield GardenTask(
      key: key,
      kind: TaskKind.harvest,
      title: 'Skörda ${(gp.customName ?? plant.namnSv).toLowerCase()}',
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
    if (dtH != null) return daysGrown >= (dtH * 0.8).round();
    return daysGrown >= 30;
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
    var due = DateTime(today.year, monthStart, 1);
    if (due.isBefore(today.subtract(const Duration(days: 14)))) {
      due = DateTime(today.year + 1, monthStart, 1);
    }
    if (due.isAfter(horizon)) return;
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

  /// Generic monthly chores — applies to the whole garden.
  Iterable<GardenTask> _choreTasksFor(DateTime today, DateTime weekAhead) sync* {
    final upcoming = _chores.upcoming(now: today);
    for (final c in upcoming) {
      // Bucket per (chore, year, month) so completing it once silences
      // it for the rest of the month.
      final dueMonth = c.month;
      final dueYear =
          (dueMonth >= today.month) ? today.year : today.year + 1;
      final due = DateTime(dueYear, dueMonth, 1);
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
