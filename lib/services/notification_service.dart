import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/garden_plant.dart';
import '../models/monthly_chore.dart';
import '../models/plant.dart';
import '../models/weather.dart';
import '../utils/zone_shift.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _enabled = true;
  int _morningHour = 8;

  static const String _enabledKey = 'notifications_enabled';
  static const String _morningHourKey = 'notification_morning_hour';

  static const String _channelId = 'plantera_main';
  static const String _channelName = 'Trädgårdspåminnelser';
  static const String _channelDesc =
      'Påminnelser om sådd, plantering, skörd och frost';

  bool get enabled => _enabled;
  int get morningHour => _morningHour;

  Future<void> initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_enabledKey) ?? true;
    _morningHour = prefs.getInt(_morningHourKey) ?? 8;
    _initialized = true;
    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosOk = await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidOk = await android?.requestNotificationsPermission() ?? true;
    return iosOk || androidOk;
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, value);
    if (!value) await cancelAll();
    notifyListeners();
  }

  Future<void> setMorningHour(int hour) async {
    _morningHour = hour.clamp(5, 12);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_morningHourKey, _morningHour);
    notifyListeners();
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      );

  /// Schedule a one-shot reminder for a specific plant action.
  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? payload,
  }) async {
    if (!_enabled) return;
    final scheduled = tz.TZDateTime.from(when, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule sowing reminder for a plant at a given month/zone.
  Future<void> schedulePlantingReminder({
    required Plant plant,
    required int zone,
    required DateTime when,
    required String action,
  }) async {
    final id = _stableId('${plant.id}-$action-${when.year}-${when.month}');
    await scheduleOneShot(
      id: id,
      title: '${plant.emoji} ${plant.namnSv}',
      body: '$action är aktuellt i zon $zone',
      when: DateTime(when.year, when.month, when.day, _morningHour),
      payload: 'plant:${plant.id}',
    );
  }

  /// Schedule planting reminders for a wishlist (säsongs-)plant. Fires
  /// on the first day of the plant's `forsadatum` window AND its
  /// `direktsadatum` window (whichever exist), for [seasonYear].
  ///
  /// Why two reminders instead of one combined: many plants offer both
  /// indoor pre-sowing and direct sowing on different schedules — e.g.
  /// tomato wants "förså inomhus" in Feb–Mar, then nothing for direkt;
  /// morötter want only direkt in Apr–Jun. Splitting lets the user
  /// catch whichever method matches their setup.
  ///
  /// Returns labels of the reminders we managed to queue (used for
  /// the SnackBar feedback). Empty list when nothing in [seasonYear]
  /// is in the future — e.g. user adds basilika in November for the
  /// current year, the windows have already closed.
  Future<List<String>> scheduleSeasonReminders({
    required String wishlistId,
    required Plant plant,
    required int zone,
    required int seasonYear,
  }) async {
    if (!_enabled) return const [];
    final scheduled = <String>[];
    final now = DateTime.now();

    Future<void> queue(String key, MonthRange? range, String label,
        String lower) async {
      if (range == null) return;
      final when =
          DateTime(seasonYear, range.startMonth, 1, _morningHour);
      if (!when.isAfter(now)) return;
      await scheduleOneShot(
        id: _stableId('wish-$wishlistId-$key'),
        title: '🌱 ${plant.namnSv}',
        body:
            'Nu öppnar säsongen för att $lower – tryck för att lägga till i trädgården.',
        when: when,
        payload: 'wishlist:$wishlistId',
      );
      // Pre-warning 7 days out so the user has time to buy frön.
      final pre = when.subtract(const Duration(days: 7));
      if (pre.isAfter(now)) {
        await scheduleOneShot(
          id: _stableId('wish-$wishlistId-$key-pre'),
          title: '🌱 ${plant.namnSv}',
          body: 'Om en vecka är det dags att $lower – köp frön i tid.',
          when: pre,
          payload: 'wishlist:$wishlistId',
        );
      }
      scheduled.add(label);
    }

    await queue(
        'forsa', plant.forsadatum, 'Förså inomhus', 'förså inomhus');
    await queue(
        'direkt', plant.direktsadatum, 'Direktså', 'direktså');
    await queue('utplant', plant.utplanteringsdatum, 'Plantera ut',
        'plantera ut');

    return scheduled;
  }

  /// Cancels every season-reminder previously scheduled for a wishlist
  /// row. Mirrors [cancelForGardenPlant] for the wishlist domain.
  Future<void> cancelForWishlist(String wishlistId) async {
    for (final key in const ['forsa', 'direkt', 'utplant']) {
      await _plugin.cancel(_stableId('wish-$wishlistId-$key'));
      await _plugin.cancel(_stableId('wish-$wishlistId-$key-pre'));
    }
  }

  /// Schedules life-cycle reminders for a plant in the user's garden.
  /// Which phases get scheduled depends on the (status, sowingMethod)
  /// pair. Previously every `planerad` plant received all four phase
  /// reminders, which produced contradictory same-day notifications
  /// like "förså inomhus" + "plantera ut" + "skörda" for the same
  /// plant. The new matrix only queues phases that haven't been
  /// completed yet, given the chosen sowing method.
  ///
  /// Matrix:
  ///   planerad + inomhus  → Förså inomhus
  ///   planerad + direkt   → Direktså
  ///   planerad + planta   → Plantera ut
  ///   forsoddInne         → Härda av (35d after planted), Plantera ut
  ///   direktsadd          → Skörd (gated on maturity)
  ///   hardad              → Plantera ut (now-ish, within 14d)
  ///   utplanterad         → Skörd (gated on maturity)
  ///   skordeklar/skordad/vilande → no scheduling
  Future<List<String>> scheduleAllForGardenPlant({
    required String gardenPlantId,
    required Plant plant,
    required int zone,
    required PlantStatus status,
    required DateTime plantedDate,
    SowingMethod sowingMethod = SowingMethod.inomhus,
  }) async {
    if (!_enabled) return const [];

    final actions = <(String, MonthRange, String, String)>[];

    switch (status) {
      case PlantStatus.planerad:
        switch (sowingMethod) {
          case SowingMethod.inomhus:
            // Fall back to direkt if the plant has no indoor window.
            if (plant.forsadatum != null) {
              actions.add(('forsa', plant.forsadatum!, 'Förså inomhus',
                  'förså inomhus'));
            } else if (plant.direktsadatum != null) {
              actions.add(
                  ('direkt', plant.direktsadatum!, 'Direktså', 'direktså'));
            }
          case SowingMethod.direkt:
            if (plant.direktsadatum != null) {
              actions.add(
                  ('direkt', plant.direktsadatum!, 'Direktså', 'direktså'));
            } else if (plant.forsadatum != null) {
              actions.add(('forsa', plant.forsadatum!, 'Förså inomhus',
                  'förså inomhus'));
            }
          case SowingMethod.planta:
            if (plant.utplanteringsdatum != null) {
              actions.add(('utplant', plant.utplanteringsdatum!, 'Plantera ut',
                  'plantera ut'));
            }
        }
      case PlantStatus.forsoddInne:
        if (plant.utplanteringsdatum != null) {
          actions.add(('utplant', plant.utplanteringsdatum!, 'Plantera ut',
              'plantera ut'));
        }
      case PlantStatus.direktsadd:
      case PlantStatus.utplanterad:
        if (plant.skordeperiod != null) {
          actions
              .add(('skord', plant.skordeperiod!, 'Skörda', 'skörda'));
        }
      case PlantStatus.hardad:
        if (plant.utplanteringsdatum != null) {
          actions.add(('utplant', plant.utplanteringsdatum!, 'Plantera ut',
              'plantera ut'));
        }
      case PlantStatus.skordeklar:
      case PlantStatus.skordad:
      case PlantStatus.vilande:
        // Terminal-or-paused — no scheduling. The plant detail screen
        // surfaces "Markera som skördad" etc. inline instead.
        break;
    }

    final now = DateTime.now();
    final scheduled = <String>[];
    for (final (key, range, label, lower) in actions) {
      // Phase-aware scheduling — the naive _nextOccurrence used to fire
      // "skörda persilja imorgon kl 8" the day a user direkt-sowed it,
      // because today's month was inside skördeperiod. The harvest and
      // plant-out actions need to also respect maturity (plantedDate +
      // grow time) before they trigger. Other phases (förså, direktså,
      // plantera ut from planerad+planta) just need calendar-aware
      // zone-shifted timing.
      DateTime mainWhen;
      if (key == 'skord') {
        mainWhen = _harvestNextOccurrence(plant, plantedDate, range, zone, now);
      } else if (key == 'utplant' && status == PlantStatus.forsoddInne) {
        mainWhen = _plantOutFromForsoddNextOccurrence(
            plantedDate, range, zone, now);
      } else {
        mainWhen = _nextOccurrenceZoned(range, now, zone);
      }
      // Pre-warning only kicks in when the main reminder is < 14 days
      // out. Apple silently drops anything past 64 pending notifications
      // so we conserve slots — the calendar window is broad and a
      // same-week pre-warning isn't useful.
      final daysToMain = mainWhen.difference(now).inDays;
      if (daysToMain <= 14 && daysToMain > 1) {
        final preWhen = mainWhen.subtract(const Duration(days: 7));
        if (preWhen.isAfter(now)) {
          await scheduleOneShot(
            id: _stableId('$gardenPlantId-$key-pre'),
            title: '${plant.emoji} ${plant.namnSv}',
            body: 'Om en vecka är det dags att $lower',
            when: preWhen,
            payload: 'plant:${plant.id}',
          );
        }
      }
      await scheduleOneShot(
        id: _stableId('$gardenPlantId-$key'),
        title: '${plant.emoji} ${plant.namnSv}',
        body: 'Nu är det dags att $lower',
        when: mainWhen,
        payload: 'plant:${plant.id}',
      );
      scheduled.add(label);
    }

    // Härda av: only relevant once a plant is actively forsoddInne. The
    // 35-day window is counted from the user's real sowing date, so a
    // tomato sown March 1 always pings April 5 regardless of when the
    // user added it to the app. Skip if the reminder would fire within
    // 24h (already overdue — dashboard surfaces it instead).
    if (status == PlantStatus.forsoddInne && plant.forsadatum != null) {
      final hardenAt = plantedDate.add(const Duration(days: 35));
      final when = DateTime(
          hardenAt.year, hardenAt.month, hardenAt.day, _morningHour);
      if (when.difference(now) > const Duration(hours: 24)) {
        await scheduleOneShot(
          id: _stableId('$gardenPlantId-harden'),
          title: '${plant.emoji} ${plant.namnSv}',
          body:
              'Dags att börja härda av — ställ ut plantorna ett par timmar dagligen i en vecka.',
          when: when,
          payload: 'plant:${plant.id}',
        );
        scheduled.add('Härda av');
      }
    }

    return scheduled;
  }

  /// Reschedule lifecycle notifications for the entire garden, dedup-ing
  /// by plant species. If the user has 3 tomato rows (one `planerad`,
  /// one `forsoddInne`, one `utplanterad`), only the most-advanced row
  /// drives notifications — so they don't get "förså inomhus tomater" +
  /// "skörda tomater" on the same morning.
  ///
  /// Also performs a light auto-transition: any `utplanterad` /
  /// `direktsadd` plant whose harvest window has started AND that has
  /// been growing > 30 days is moved to `skordeklar` (terminal — no
  /// further notifications), eliminating the "skörda" notice on a plant
  /// the user already ate.
  ///
  /// Should be called on app launch and whenever garden contents change.
  Future<List<GardenPlant>> rescheduleAllForGarden({
    required List<GardenPlant> garden,
    required Plant? Function(String) plantLookup,
    required int zone,
  }) async {
    if (!_enabled) return garden;

    // 1. Auto-transition utplanterad/direktsadd → skordeklar when
    //    skordeperiod has started + plant has been outside long enough.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transitioned = <GardenPlant>[];
    for (final gp in garden) {
      final p = plantLookup(gp.plantId);
      if (p == null || p.skordeperiod == null) {
        transitioned.add(gp);
        continue;
      }
      final plantedDay = DateTime(
          gp.plantedDate.year, gp.plantedDate.month, gp.plantedDate.day);
      final daysSincePlanted = today.difference(plantedDay).inDays;
      final harvestWindowOpen = p.skordeperiod!.includes(now.month);
      final shouldRipen = (gp.status == PlantStatus.utplanterad ||
              gp.status == PlantStatus.direktsadd) &&
          harvestWindowOpen &&
          daysSincePlanted >= 30;
      transitioned.add(
          shouldRipen ? gp.copyWith(status: PlantStatus.skordeklar) : gp);
    }

    // 2. Cancel everything currently scheduled.
    for (final gp in garden) {
      await cancelForGardenPlant(gp.id);
    }

    // 3. Dedup by plant_id — pick the most-advanced status per species.
    final byPlant = <String, GardenPlant>{};
    for (final gp in transitioned) {
      final existing = byPlant[gp.plantId];
      if (existing == null ||
          _statusOrder(gp.status) > _statusOrder(existing.status)) {
        byPlant[gp.plantId] = gp;
      }
    }

    // 4. Schedule notifications only for the picked representative per
    //    species. Other rows of the same species stay in the garden but
    //    don't add their own pings.
    for (final gp in byPlant.values) {
      final plant = plantLookup(gp.plantId);
      if (plant == null) continue;
      await scheduleAllForGardenPlant(
        gardenPlantId: gp.id,
        plant: plant,
        zone: zone,
        status: gp.status,
        plantedDate: gp.plantedDate,
        sowingMethod: gp.sowingMethod,
      );
      // Per-plant care-task notifications are *not* scheduled here
      // anymore — they're rolled up into a single morning digest by
      // [scheduleCareDigest], which the main.dart coordinator calls
      // after this returns. Without the digest a user with 30 plants
      // would get 60-100 individual pings/year; the digest collapses
      // them to one per month.
      await _cancelCareTasks(gp.id);
    }

    // Return the (possibly auto-transitioned) garden so the caller can
    // persist any state changes. Caller compares to original to know
    // which rows to update.
    return transitioned;
  }

  /// Stable ordering of states for "more advanced than" comparison
  /// inside [rescheduleAllForGarden]'s dedup. Higher = further along
  /// in the lifecycle.
  static int _statusOrder(PlantStatus s) => switch (s) {
        PlantStatus.planerad => 0,
        PlantStatus.forsoddInne => 1,
        PlantStatus.direktsadd => 2,
        PlantStatus.hardad => 3,
        PlantStatus.utplanterad => 4,
        PlantStatus.skordeklar => 5,
        PlantStatus.skordad => 6,
        PlantStatus.vilande => 7,
      };

  /// Cancels every life-cycle reminder previously scheduled for a gardenPlant.
  /// Care-task notifications are cancelled separately by id-prefix scan
  /// in [_cancelCareTasks] because the set of task ids is plant-specific
  /// and we don't want a hardcoded list per species.
  Future<void> cancelForGardenPlant(String gardenPlantId) async {
    // 'harden' was missing from the cancel-list before, leaving stale
    // härda av-notiser scheduled when a plant moved from forsoddInne to
    // utplanterad before the +35d trigger.
    for (final key in const [
      'forsa',
      'direkt',
      'utplant',
      'skord',
      'harden'
    ]) {
      await _plugin.cancel(_stableId('$gardenPlantId-$key'));
      await _plugin.cancel(_stableId('$gardenPlantId-$key-pre'));
    }
    await _plugin.cancel(_stableId('$gardenPlantId-harden'));
    await _cancelCareTasks(gardenPlantId);
  }

  /// Schedule recurring annual care reminders ("beskär äpple", "gödsla
  /// rosor"…) for each [CareTask] on a plant. Fires on the first day of
  /// the task's month range at the user's preferred morning hour.
  ///
  /// Two reminders per task: a one-week heads-up and the day itself.
  /// Schedules for *this year* if the window hasn't started, otherwise
  /// for next year — so a perennial added in July still gets next
  /// February's beskärnings-påminnelse queued immediately.
  ///
  /// We also remember which task ids we scheduled per garden plant in
  /// [_careTaskIds] so cancellation can hit the same set without
  /// requiring the original Plant lookup later.
  Future<List<String>> scheduleCareTasks({
    required String gardenPlantId,
    required Plant plant,
  }) async {
    if (!_enabled) return const [];
    if (plant.omsorg.isEmpty) return const [];

    final scheduled = <String>[];
    final ids = <String>[];
    final now = DateTime.now();

    for (final task in plant.omsorg) {
      // Pick the next occurrence of the start month.
      var when = DateTime(
          now.year, task.month.startMonth, 1, _morningHour);
      if (!when.isAfter(now)) {
        // Window already started this year — but if we're still inside
        // the range, schedule "tomorrow morning" so the user gets a
        // ping for the active task today rather than next year.
        if (task.month.includes(now.month)) {
          final tomorrow = now.add(const Duration(days: 1));
          when = DateTime(
              tomorrow.year, tomorrow.month, tomorrow.day, _morningHour);
        } else {
          when = DateTime(
              now.year + 1, task.month.startMonth, 1, _morningHour);
        }
      }

      final mainKey = '$gardenPlantId-care-${task.id}';
      await scheduleOneShot(
        id: _stableId(mainKey),
        title: '${plant.emoji} ${plant.namnSv}',
        body: task.title.isEmpty
            ? task.description
            : '${task.title} – ${task.description}',
        when: when,
        payload: 'care:$gardenPlantId:${task.id}',
      );
      ids.add(task.id);

      // Pre-warning seven days before — same pattern as lifecycle
      // reminders. Skipped when the task fires within a week (avoids
      // scheduling a pre-warning for the past).
      final daysToMain = when.difference(now).inDays;
      if (daysToMain > 7) {
        final pre = when.subtract(const Duration(days: 7));
        await scheduleOneShot(
          id: _stableId('$mainKey-pre'),
          title: '${plant.emoji} ${plant.namnSv}',
          body: 'Om en vecka: ${task.title.toLowerCase()}',
          when: pre,
          payload: 'care:$gardenPlantId:${task.id}',
        );
      }
      scheduled.add(task.title);
    }

    _careTaskIds[gardenPlantId] = ids;
    return scheduled;
  }

  /// Per-garden-plant cache of which CareTask ids were scheduled, so
  /// cancellation can target exactly those without re-resolving the
  /// Plant. Lives in memory; on cold start [rescheduleAllForGarden]
  /// will re-cancel-then-schedule which repopulates it.
  final Map<String, List<String>> _careTaskIds = {};

  Future<void> _cancelCareTasks(String gardenPlantId) async {
    final ids = _careTaskIds[gardenPlantId];
    if (ids == null) return;
    for (final taskId in ids) {
      await _plugin.cancel(_stableId('$gardenPlantId-care-$taskId'));
      await _plugin.cancel(_stableId('$gardenPlantId-care-$taskId-pre'));
    }
    _careTaskIds.remove(gardenPlantId);
  }

  /// Roll up CareTasks (per-plant) and MonthlyChores (generic) into one
  /// morning notification per upcoming month. With 30 plants × 3-4
  /// tasks = 100+ pings per year if scheduled individually; the digest
  /// collapses those to ~12 — one on the first morning of each month.
  ///
  /// Call this once after rescheduleAllForGarden, not per-plant.
  /// [chores] is optional — when null we still digest CareTasks alone.
  Future<List<String>> scheduleCareDigest({
    required List<GardenPlant> garden,
    required Plant? Function(String) plantLookup,
    List<MonthlyChore> chores = const [],
  }) async {
    if (!_enabled) return const [];

    // 1. Cancel any existing digest entries for the next 12 months so
    //    a stale digest doesn't fire after the garden has changed.
    final now = DateTime.now();
    for (var i = 0; i < 12; i++) {
      final m = DateTime(now.year, now.month + i, 1);
      await _plugin.cancel(_stableId('digest-${m.year}-${m.month}'));
    }

    // 2. Build per-month task lists.
    final scheduled = <String>[];
    for (var i = 0; i < 12; i++) {
      final monthDate = DateTime(now.year, now.month + i, 1, _morningHour);
      if (!monthDate.isAfter(now)) continue;
      final month = monthDate.month;

      // a) Plant-specific care tasks for this month, dedup per
      //    (species, taskId) so "beskär äpple" from two apple trees
      //    becomes one line.
      final careLines = <String>[];
      final seenSpecies = <String, Set<String>>{};
      for (final gp in garden) {
        final p = plantLookup(gp.plantId);
        if (p == null) continue;
        for (final task in p.omsorg) {
          if (task.month.startMonth != month) continue;
          final taskSet = seenSpecies.putIfAbsent(p.id, () => <String>{});
          if (!taskSet.add(task.id)) continue;
          careLines.add('${p.emoji} ${task.title.toLowerCase()}');
          if (careLines.length >= 6) break;
        }
        if (careLines.length >= 6) break;
      }

      // b) Generic monthly chores for this month — already represent
      //    common Swedish gardening tasks regardless of what's grown.
      final choreLines = chores
          .where((c) => c.month == month)
          .take(4)
          .map((c) => '${c.emoji} ${c.title.toLowerCase()}')
          .toList();

      final allLines = [...careLines, ...choreLines];
      if (allLines.isEmpty) continue;

      final monthName = _swedishMonth(month);
      final body = allLines.length == 1
          ? 'I $monthName: ${allLines.first}.'
          : 'I $monthName: ${allLines.take(3).join(", ")}'
              '${allLines.length > 3 ? " m.fl." : "."}';

      await scheduleOneShot(
        id: _stableId('digest-${monthDate.year}-${monthDate.month}'),
        title: '🌱 Trädgårdsmorgon',
        body: body,
        when: monthDate,
        payload: 'digest',
      );
      scheduled.add('$monthName (${allLines.length})');
    }
    return scheduled;
  }

  String _swedishMonth(int m) => const [
        '',
        'januari',
        'februari',
        'mars',
        'april',
        'maj',
        'juni',
        'juli',
        'augusti',
        'september',
        'oktober',
        'november',
        'december',
      ][m];

  /// Zone-aware next-occurrence picker — applies [ZoneShift] so a
  /// "förså inomhus"-reminder fires later in Norrland än i Skåne.
  /// Replaces the old naive _nextOccurrence (which scheduled "tomorrow"
  /// for any plant whose phase was ongoing — too aggressive).
  DateTime _nextOccurrenceZoned(MonthRange range, DateTime from, int zone) {
    final shiftedThisYear =
        ZoneShift.shiftSeasonStart(from.year, range.startMonth, zone);
    final shiftedAtMorning = DateTime(shiftedThisYear.year,
        shiftedThisYear.month, shiftedThisYear.day, _morningHour);
    if (shiftedAtMorning.isAfter(from)) return shiftedAtMorning;
    if (range.includes(from.month)) {
      // We're already inside the season — schedule for tomorrow morning.
      return DateTime(from.year, from.month, from.day, _morningHour)
          .add(const Duration(days: 1));
    }
    final next =
        ZoneShift.shiftSeasonStart(from.year + 1, range.startMonth, zone);
    return DateTime(next.year, next.month, next.day, _morningHour);
  }

  /// Earliest realistic harvest-reminder date for an annual / biennial
  /// plant. The bug we're fixing here: a persilja direkt-sown today in
  /// May immediately had "skörda persilja imorgon kl 8" scheduled,
  /// because today's month was within skördeperiod (maj-okt). Now the
  /// reminder waits until the plant has actually had time to grow.
  ///
  /// Rules:
  ///   - perennial / tree / shrub → next zone-shifted skördeperiod
  ///     start (plant is mature, plantedDate doesn't matter)
  ///   - annual / biennial → max of plantedDate + 80% of dagarTillSkord
  ///     and the zone-shifted season start. Falls back to +30 days when
  ///     dagarTillSkord is missing (rough heuristic for herbs/leafy
  ///     greens that don't have a hard maturity number).
  DateTime _harvestNextOccurrence(Plant plant, DateTime plantedDate,
      MonthRange range, int zone, DateTime from) {
    final thisYearStart =
        ZoneShift.shiftSeasonStart(from.year, range.startMonth, zone);
    final nextYearStart =
        ZoneShift.shiftSeasonStart(from.year + 1, range.startMonth, zone);

    final isLongLived = plant.livscykel == PlantLifecycle.perennial ||
        plant.livscykel == PlantLifecycle.tree ||
        plant.livscykel == PlantLifecycle.shrub;

    if (isLongLived) {
      final thisYearMorning = DateTime(thisYearStart.year,
          thisYearStart.month, thisYearStart.day, _morningHour);
      if (thisYearMorning.isAfter(from)) return thisYearMorning;
      if (range.includes(from.month)) {
        return DateTime(from.year, from.month, from.day, _morningHour)
            .add(const Duration(days: 1));
      }
      return DateTime(nextYearStart.year, nextYearStart.month,
          nextYearStart.day, _morningHour);
    }

    // Annuals & biennials: maturity must accumulate from plantedDate.
    final maturityDays = plant.dagarTillSkord != null
        ? (plant.dagarTillSkord! * 0.8).round()
        : 30;
    final earliestByMaturity = plantedDate.add(Duration(days: maturityDays));

    // Whichever lands later — both season AND plant must be ready.
    final candidate = earliestByMaturity.isAfter(thisYearStart)
        ? earliestByMaturity
        : thisYearStart;
    final morning = DateTime(
        candidate.year, candidate.month, candidate.day, _morningHour);

    if (morning.isAfter(from)) return morning;

    // Past — plant is overdue. Schedule tomorrow morning so the user
    // gets at least one nudge to actually go harvest.
    return DateTime(from.year, from.month, from.day, _morningHour)
        .add(const Duration(days: 1));
  }

  /// Earliest realistic plant-out reminder for a plant currently in
  /// [PlantStatus.forsoddInne]. Same shape as [_harvestNextOccurrence]
  /// but the maturity gate is fixed at 28 days indoors regardless of
  /// species — the threshold below which seedlings simply aren't ready
  /// to go out, no matter what the calendar says.
  DateTime _plantOutFromForsoddNextOccurrence(
      DateTime plantedDate, MonthRange range, int zone, DateTime from) {
    final thisYearStart =
        ZoneShift.shiftSeasonStart(from.year, range.startMonth, zone);
    final earliestByMaturity =
        plantedDate.add(const Duration(days: 28));
    final candidate = earliestByMaturity.isAfter(thisYearStart)
        ? earliestByMaturity
        : thisYearStart;
    final morning = DateTime(
        candidate.year, candidate.month, candidate.day, _morningHour);
    if (morning.isAfter(from)) return morning;
    return DateTime(from.year, from.month, from.day, _morningHour)
        .add(const Duration(days: 1));
  }

  /// Re-schedules every weather-driven contextual warning (frost, heatwave,
  /// dry spell) based on the current forecast and the plants in the user's
  /// garden. Should be called whenever either weather forecast or garden
  /// contents change. All previously scheduled contextual notifications for
  /// the next 11 days are cancelled first to avoid stale alerts.
  Future<List<String>> refreshContextualWarnings({
    required List<WeatherDay> forecast,
    required List<GardenPlant> garden,
    required Plant? Function(String plantId) plantLookup,
    double? rainLast14d,
  }) async {
    if (!_enabled) return const [];

    // Cancel pending contextual warnings before re-scheduling. We only
    // know about the next ~11 days, so iterate that span.
    final today = DateTime.now();
    for (var i = 0; i < 11; i++) {
      final d = today.add(Duration(days: i));
      await _plugin.cancel(_stableId('frost-${d.year}-${d.month}-${d.day}'));
    }
    await _plugin.cancel(_stableId('heatwave-current'));
    await _plugin.cancel(_stableId('dryperiod-current'));

    final scheduled = <String>[];
    // Plants that are physically outside and could be hurt by weather.
    // The model's `isOutdoorActive` covers direktsadd, hardad, utplanterad,
    // and skordeklar — older code only checked utplanterad/skordeklar so
    // direkt-sown seedlings were silently excluded from frost warnings.
    final hasOutdoor = garden.any((gp) => gp.status.isOutdoorActive);

    // 1. Per-night frost warnings for frost-sensitive outdoor plants.
    for (final day in forecast.where((d) => d.isFrostRisk)) {
      final sensitive = <Plant>[];
      final seenIds = <String>{};
      for (final gp in garden) {
        if (!gp.status.isOutdoorActive) continue;
        final p = plantLookup(gp.plantId);
        if (p == null) continue;
        if (!p.isFrostSensitive(day.minTempC)) continue;
        // Deduplicate by species: 5 tomato plants shouldn't render as
        // "täck dina tomater, tomater, tomater".
        if (!seenIds.add(p.id)) continue;
        sensitive.add(p);
      }
      if (sensitive.isEmpty) continue;

      final names = sensitive
          .map((p) => p.namnSv.toLowerCase())
          .take(3)
          .join(', ');
      final more = sensitive.length > 3 ? ' m.fl.' : '';
      final tempStr = day.minTempC.toStringAsFixed(0);
      final body = sensitive.length == 1
          ? 'I natt väntas $tempStr°C – täck dina $names.'
          : 'I natt väntas $tempStr°C – täck $names$more.';

      // Notify 18:00 the evening before the frosty night.
      final notifTime = DateTime(
        day.date.year,
        day.date.month,
        day.date.day,
      ).subtract(const Duration(hours: 6));
      if (notifTime.isAfter(today)) {
        await scheduleOneShot(
          id: _stableId(
              'frost-${day.date.year}-${day.date.month}-${day.date.day}'),
          title: '❄️ Frostvarning i natt',
          body: body,
          when: notifTime,
          payload: 'frost',
        );
        scheduled.add('Frost ${DateFormat('d MMM').format(day.date)}');
      }
    }

    // 2. Heatwave: 3+ consecutive days with max ≥ 25°C in the forecast,
    // and the user actually has outdoor plants to worry about.
    if (hasOutdoor) {
      var run = <WeatherDay>[];
      List<WeatherDay>? heatRun;
      for (final d in forecast) {
        if (d.maxTempC >= 25) {
          run.add(d);
          if (run.length >= 3) {
            heatRun = List<WeatherDay>.from(run);
            break;
          }
        } else {
          run = [];
        }
      }
      if (heatRun != null) {
        final start = heatRun.first.date;
        var notifTime =
            DateTime(start.year, start.month, start.day, _morningHour)
                .subtract(const Duration(days: 1));
        // If the heatwave has already started (notif time would be in
        // the past), notify in 1 hour instead of skipping entirely —
        // the user still benefits from "next 3 days are scorching".
        if (notifTime.isBefore(today)) {
          notifTime = today.add(const Duration(hours: 1));
        }
        await scheduleOneShot(
          id: _stableId('heatwave-current'),
          title: '🔥 Värmebölja på väg',
          body:
              'Flera varma dagar väntas – vattna noga, skugga känsliga växter och kontrollera krukor dagligen.',
          when: notifTime,
          payload: 'heatwave',
        );
        scheduled.add('Värmebölja');
      }
    }

    // 3. Dry spell — combines history + forecast + per-plant water need.
    //
    // Old logic only looked at the 7-day forecast: "less than 5mm expected
    // → warn". That misses two cases:
    //   a) it hasn't rained in 12 days but tomorrow brings 6mm — old code
    //      stayed silent even though most plants are already stressed.
    //   b) rosmarin and lavendel actually like dry; alerting at the same
    //      threshold as a thirsty basil produces noise.
    //
    // New logic: combine historical 14-day rain (`rainLast14d`, from
    // Open-Meteo) with the next-7-day forecast into a single budget. Tier
    // outdoor plants by `WaterNeed.riklig` — those get warned at a
    // higher (drier) threshold than the rest.
    if (hasOutdoor) {
      final next7Total = forecast.length >= 7
          ? forecast.take(7).fold<double>(0, (s, d) => s + d.precipitationMm)
          : null;
      final past14 = rainLast14d;

      // Need at least one signal to trigger. Prefer combining; fall back
      // to whichever is available.
      double? combined;
      if (past14 != null && next7Total != null) {
        combined = past14 + next7Total;
      } else if (next7Total != null) {
        combined = next7Total;
      } else if (past14 != null) {
        combined = past14;
      }

      if (combined != null) {
        // Find the highest water-need among outdoor plants. If anyone
        // out there is `riklig` (basil, lettuce, cucumber…) we use the
        // tighter threshold — they suffer first.
        var anyThirsty = false;
        var anyOutdoor = false;
        final seenIds = <String>{};
        for (final gp in garden) {
          if (!gp.status.isOutdoorActive) continue;
          final p = plantLookup(gp.plantId);
          if (p == null) continue;
          if (!seenIds.add(p.id)) continue;
          anyOutdoor = true;
          if (p.vattning == WaterNeed.riklig) anyThirsty = true;
        }
        if (anyOutdoor) {
          // Thresholds in mm of *combined* (past 14 + next 7) rain.
          // Calibrated against typical Swedish summer rainfall (~25mm/14d
          // is normal-wet, ~10mm/14d is dry, <5mm is drought).
          final threshold = anyThirsty ? 12.0 : 6.0;
          if (combined < threshold) {
            final tomorrow = today.add(const Duration(days: 1));
            final notifTime = DateTime(
                tomorrow.year, tomorrow.month, tomorrow.day, _morningHour);
            final body = past14 != null
                ? 'Endast ${past14.toStringAsFixed(0)} mm regn senaste 14 dagar och lite på väg – vattna noga, särskilt nyplanterade och i krukor.'
                : 'Mycket lite nederbörd väntas kommande vecka – håll koll på vattningen, särskilt nyplanterade och i krukor.';
            await scheduleOneShot(
              id: _stableId('dryperiod-current'),
              title: '☀️ Torrperiod pågår',
              body: body,
              when: notifTime,
              payload: 'dryperiod',
            );
            scheduled.add('Torrperiod');
          }
        }
      }
    }

    return scheduled;
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pending() =>
      _plugin.pendingNotificationRequests();

  int _stableId(String key) {
    var hash = 0;
    for (final c in key.codeUnits) {
      hash = (hash * 31 + c) & 0x7fffffff;
    }
    return hash;
  }
}
