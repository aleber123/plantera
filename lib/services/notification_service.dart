import 'dart:io' show Platform;

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
import 'notification_strings.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final NotificationStrings _strings = NotificationStrings();
  bool _initialized = false;
  bool _enabled = true;
  int _morningHour = 8;

  /// Update which language notifications fire in. Called from main.dart's
  /// MaterialApp builder once iOS has resolved the user's preferred
  /// Sets the locale used for notification text generation. Fires
  /// `notifyListeners` so the main-level pipeline can re-schedule all
  /// pending notifications with the new language — without this,
  /// already-scheduled pings stay in the old language until they fire.
  void setLocale(String localeCode) {
    if (_strings.localeCode == localeCode) return;
    _strings.setLocale(localeCode);
    notifyListeners();
  }
  String get localeCode => _strings.localeCode;

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

  /// Returns true only when the user has granted permission on the
  /// CURRENT platform. Previously this returned `iosOk || androidOk`
  /// which silently lied on iOS-denied devices that happened to be
  /// running Android builds in some test matrix — and made the
  /// settings toggle render "ON" when notifications could never
  /// actually fire.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? true;
    }
    return false;
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
      // Zone-shift the season start like every other scheduling path —
      // without this Norrland (zon 7) got "dags att så" 28 dagar för
      // tidigt och Skåne (zon 1) 14 dagar för sent.
      final shifted =
          ZoneShift.shiftSeasonStart(seasonYear, range.startMonth, zone);
      final when = DateTime(
          shifted.year, shifted.month, shifted.day, _morningHour);
      if (!when.isAfter(now)) return;
      await scheduleOneShot(
        id: _stableId('wish-$wishlistId-$key'),
        title: '🌱 ${plant.namnSv}',
        body: _strings.wishlistBody(lower),
        when: when,
        payload: 'wishlist:$wishlistId',
      );
      final pre = when.subtract(const Duration(days: 7));
      if (pre.isAfter(now)) {
        await scheduleOneShot(
          id: _stableId('wish-$wishlistId-$key-pre'),
          title: '🌱 ${plant.namnSv}',
          body: _strings.wishlistPre(lower),
          when: pre,
          payload: 'wishlist:$wishlistId',
        );
      }
      scheduled.add(label);
    }

    await queue('forsa', plant.forsadatum, _strings.labelForsa(),
        _strings.actionForsa());
    await queue('direkt', plant.direktsadatum, _strings.labelDirekt(),
        _strings.actionDirekt());
    await queue('utplant', plant.utplanteringsdatum,
        _strings.labelUtplant(), _strings.actionUtplant());

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

    final lblForsa = _strings.labelForsa();
    final actForsa = _strings.actionForsa();
    final lblDirekt = _strings.labelDirekt();
    final actDirekt = _strings.actionDirekt();
    final lblUtplant = _strings.labelUtplant();
    final actUtplant = _strings.actionUtplant();
    final lblSkord = _strings.labelSkord();
    final actSkord = _strings.actionSkord();

    switch (status) {
      case PlantStatus.planerad:
        switch (sowingMethod) {
          case SowingMethod.inomhus:
            if (plant.forsadatum != null) {
              actions.add(
                  ('forsa', plant.forsadatum!, lblForsa, actForsa));
            } else if (plant.direktsadatum != null) {
              actions.add(
                  ('direkt', plant.direktsadatum!, lblDirekt, actDirekt));
            }
          case SowingMethod.direkt:
            if (plant.direktsadatum != null) {
              actions.add(
                  ('direkt', plant.direktsadatum!, lblDirekt, actDirekt));
            } else if (plant.forsadatum != null) {
              actions.add(
                  ('forsa', plant.forsadatum!, lblForsa, actForsa));
            }
          case SowingMethod.planta:
            if (plant.utplanteringsdatum != null) {
              actions.add(('utplant', plant.utplanteringsdatum!,
                  lblUtplant, actUtplant));
            }
        }
      case PlantStatus.forsoddInne:
        if (plant.utplanteringsdatum != null) {
          actions.add(('utplant', plant.utplanteringsdatum!,
              lblUtplant, actUtplant));
        }
      case PlantStatus.direktsadd:
      case PlantStatus.utplanterad:
        if (plant.skordeperiod != null) {
          actions.add(('skord', plant.skordeperiod!, lblSkord, actSkord));
        }
      case PlantStatus.hardad:
        if (plant.utplanteringsdatum != null) {
          actions.add(('utplant', plant.utplanteringsdatum!,
              lblUtplant, actUtplant));
        }
      case PlantStatus.skordeklar:
      case PlantStatus.skordad:
      case PlantStatus.vilande:
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
            body: _strings.bodyPre(lower),
            when: preWhen,
            payload: 'plant:${plant.id}',
          );
        }
      }
      await scheduleOneShot(
        id: _stableId('$gardenPlantId-$key'),
        title: '${plant.emoji} ${plant.namnSv}',
        body: _strings.bodyNow(lower),
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
          body: _strings.hardenBody(),
          when: when,
          payload: 'plant:${plant.id}',
        );
        scheduled.add(_strings.labelHarden());
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
    // 1. Auto-transition utplanterad/direktsadd → skordeklar when
    //    skordeperiod has started + plant has been outside long enough.
    //    Runs unconditionally — this is a correctness migration that
    //    must happen even when the user has notifications disabled,
    //    otherwise plant_detail_screen never surfaces "Markera som
    //    skördad" for ripened produce.
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

    // Notifications disabled — still return the auto-transitions so
    // the caller can persist them, just don't touch the schedule.
    if (!_enabled) return transitioned;

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

  // DEAD: per-plant care reminders were replaced by the rolled-up
  // [scheduleCareDigest] (one morning digest per month instead of
  // 60-100 individual pings/year). The old per-task `scheduleCareTasks`
  // was the only writer of [_careTaskIds]; with it gone the map is
  // always empty and [_cancelCareTasks] is provably a no-op. The two
  // remaining call-sites ([rescheduleAllForGarden], [cancelForGardenPlant])
  // keep calling it harmlessly so the cancel path stays correct if the
  // per-task scheduler ever comes back.
  final Map<String, List<String>> _careTaskIds = {};

  Future<void> _cancelCareTasks(String gardenPlantId) async {
    final ids = _careTaskIds[gardenPlantId];
    if (ids == null) return; // DEAD: always taken — map is never written.
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

      // b) Generic monthly chores for this month — filter against the
      //    user's actual plants so "Gallra äpple och plommon" doesn't
      //    appear in the digest when there are no fruit trees.
      final userPlantIds = garden.map((gp) => gp.plantId).toSet();
      final userCategories = <String>{};
      for (final gp in garden) {
        final p = plantLookup(gp.plantId);
        if (p != null) userCategories.add(p.kategori.name);
      }
      final choreLines = chores
          .where((c) {
            if (c.month != month) return false;
            if (c.isUniversal) return true;
            final matchesPlant =
                c.appliesToPlants.any(userPlantIds.contains);
            final matchesCategory =
                c.appliesToCategories.any(userCategories.contains);
            return matchesPlant || matchesCategory;
          })
          .take(4)
          .map((c) => '${c.emoji} ${c.title.toLowerCase()}')
          .toList();

      final allLines = [...careLines, ...choreLines];
      if (allLines.isEmpty) continue;

      final monthName = _strings.monthName(month);
      final body = allLines.length == 1
          ? _strings.digestBodyOne(monthName, allLines.first)
          : _strings.digestBodyMany(
              monthName,
              allLines.take(3).join(', '),
              hasMore: allLines.length > 3,
            );

      await scheduleOneShot(
        id: _stableId('digest-${monthDate.year}-${monthDate.month}'),
        title: _strings.digestTitle(),
        body: body,
        when: monthDate,
        payload: 'digest',
      );
      scheduled.add('$monthName (${allLines.length})');
    }
    return scheduled;
  }

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

    // Cancel pending contextual warnings before re-scheduling. Use the
    // actual forecast length (instead of a hard-coded 11 days) so a
    // forecast provider with longer reach doesn't leave stale frost
    // warnings armed beyond the cancel window. Add a small safety
    // overshoot (+3 days) for cases where today's call shortens the
    // forecast versus the previous call.
    final today = DateTime.now();
    final cancelSpan = (forecast.length + 3).clamp(11, 31);
    for (var i = 0; i < cancelSpan; i++) {
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
      final tempStr = day.minTempC.toStringAsFixed(0);
      final body = sensitive.length == 1
          ? _strings.frostBodyOne(tempStr, names)
          : _strings.frostBodyMany(tempStr, names,
              hasMore: sensitive.length > 3);

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
          title: _strings.frostTitle(),
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
          title: _strings.heatwaveTitle(),
          body: _strings.heatwaveBody(),
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
                ? _strings.dryBodyHistorical(past14.toStringAsFixed(0))
                : _strings.dryBodyForecast();
            await scheduleOneShot(
              id: _stableId('dryperiod-current'),
              title: _strings.dryTitle(),
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

  /// Schedule a recurring set of "season-peak" notifications that nudge
  /// the user back into the app at the moments where Swedish hobby
  /// gardeners convert best (Feb pre-sow, Apr direct-sow, Jul harvest,
  /// Sep bulb planting, Nov year-review). Each is informational and
  /// kept light — the goal is *return-to-app* engagement, which
  /// indirectly drives premium conversion.
  ///
  /// Idempotent — stable IDs derived from (campaign-tag, year) so re-
  /// running on every app boot just upserts. Fires the year passed in,
  /// then re-schedules for [year+1] so a user who returns in Dec 2026
  /// still has Feb 2027's nudge queued.
  ///
  /// Skips notifications already in the past so a Nov-installed user
  /// doesn't get spammed with the year's earlier checkpoints.
  Future<int> scheduleSeasonalCampaign({required int year}) async {
    if (!_enabled) return 0;

    // (month, day) anchors. Title/body are localised per-call via
    // _strings.campaignTitle/Body so a German user sees German nudges
    // rather than Swedish ones.
    final campaigns = <(int, int)>[
      (2, 15),
      (3, 15),
      (4, 15),
      (7, 1),
      (9, 15),
      (11, 15),
    ];

    var scheduled = 0;
    final now = DateTime.now();
    // Cancel the whole campaign set first so a re-call after the locale
    // has resolved (setLocale → main re-schedules) cleanly replaces the
    // old-language pushes. IDs are stable per (month, year) and locale-
    // independent, so a future entry is also upserted by the schedule
    // below; this cancel additionally clears any entry that has since
    // slipped into the past (and is skipped below) but was queued in the
    // previous locale.
    for (final yr in [year, year + 1]) {
      for (final c in campaigns) {
        await _plugin.cancel(_stableId('season-${c.$1}-$yr'));
      }
    }
    // Budget against the iOS 64-slot cap — frost/time-critical warnings
    // take priority over these engagement nudges, so once the pending
    // list is near the cap we stop queuing campaign pushes.
    final budget = await _remainingSlots();
    // Schedule for the current year if still in the future, plus next
    // year so a fall-installed user has spring covered. Limit to two
    // years to bound the pending-notification list (Apple caps at 64).
    // Title/body are read from `_strings` at call time so the CURRENT
    // resolved locale wins.
    for (final yr in [year, year + 1]) {
      for (final c in campaigns) {
        final when = DateTime(yr, c.$1, c.$2, _morningHour);
        if (when.isBefore(now)) continue;
        if (scheduled >= budget) return scheduled;
        await scheduleOneShot(
          id: _stableId('season-${c.$1}-$yr'),
          title: _strings.campaignTitle(c.$1),
          body: _strings.campaignBody(c.$1),
          when: when,
          payload: 'season:${c.$1}:$yr',
        );
        scheduled++;
      }
    }
    return scheduled;
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pending() =>
      _plugin.pendingNotificationRequests();

  /// iOS silently drops anything past 64 pending notifications, and it
  /// drops the *newest* schedule attempts — which would be the frost /
  /// time-critical warnings if low-value engagement nudges had already
  /// filled the queue. To keep behaviour deterministic we reserve a
  /// block of slots for those warnings and let lower-priority schedulers
  /// (the seasonal campaign) consult [_remainingSlots] before queuing.
  static const int _iosPendingCap = 64;
  static const int _criticalReserve = 16;

  /// How many *additional* notifications a low-priority scheduler may
  /// queue without risking the cap. Counts what's already pending and
  /// keeps [_criticalReserve] slots free for frost/time-critical alerts.
  /// Returns 0 (never negative) when the queue is already saturated.
  Future<int> _remainingSlots() async {
    final current = (await pending()).length;
    final free = _iosPendingCap - _criticalReserve - current;
    return free > 0 ? free : 0;
  }

  /// Convert a string scheduling key into the 32-bit positive int that
  /// flutter_local_notifications uses for cancel/pending lookups.
  ///
  /// We use FNV-1a (64-bit internal state, folded to 31 bits) instead
  /// of the classic `hash * 31 + c` because the multiply-31 variant
  /// distributes poorly over the namespace we use ("uuid-key-suffix")
  /// and produced realistic collisions with ~100 active reminders
  /// across (plant lifecycle × wishlist × care × digest × frost ×
  /// heatwave × season campaign). FNV-1a's avalanche properties give
  /// effectively zero collision risk for the volume Plantera produces.
  int _stableId(String key) {
    // FNV-1a 64-bit constants. Dart ints are 64-bit on native — safe.
    const int offsetBasis = 0xcbf29ce484222325;
    const int fnvPrime = 0x100000001b3;
    int hash = offsetBasis;
    for (final c in key.codeUnits) {
      hash ^= c;
      hash = (hash * fnvPrime) & 0xffffffffffffffff;
    }
    // Fold to 31 bits (positive int) — local_notifications can't take
    // negative IDs on Android.
    return ((hash ^ (hash >> 32)) & 0x7fffffff);
  }
}
