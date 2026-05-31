import 'dart:async';
import 'dart:io' show Platform;
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/intro_screen.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/ad_service.dart';
import 'services/garden_service.dart';
import 'services/harvest_service.dart';
import 'services/monthly_chores_service.dart';
import 'services/notification_service.dart';
import 'services/pest_library_service.dart';
import 'services/plant_database_service.dart';
import 'services/task_service.dart';
import 'services/premium_service.dart';
import 'services/season_planner_service.dart';
import 'services/ui_settings_service.dart';
import 'services/weather_service.dart';
import 'services/zone_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final premium = PremiumService();
  final db = PlantDatabaseService();
  final garden = GardenService();
  final harvest = HarvestService();
  final weather = WeatherService();
  final notifications = NotificationService();
  final ui = UISettingsService();
  final chores = MonthlyChoresService();
  final pests = PestLibraryService();
  final tasks = TaskService();

  // GardenService must boot before ZoneService, SeasonPlannerService
  // and TaskService — all three depend on the active-garden state and
  // the v5 schema migration (which creates the task tables).
  await garden.initialize();
  final zone = ZoneService(garden);
  final season = SeasonPlannerService();

  await Future.wait([
    premium.initialize(),
    zone.initialize(),
    db.load(),
    harvest.initialize(),
    notifications.initialize(),
    ui.initialize(),
    chores.load(),
    pests.load(),
  ]);
  await season.initialize();
  // TaskService depends on PlantDatabaseService (db.load), GardenService
  // and MonthlyChoresService having loaded — boot last.
  await tasks.initialize();

  if (zone.lat != null && zone.lon != null) {
    // Fire-and-forget – don't block app startup on network.
    weather.fetch(zone.lat!, zone.lon!);
  }
  // When the user switches active garden, refetch weather for the new
  // location. Different gardens = different micro-climates.
  garden.addListener(() {
    if (zone.lat != null && zone.lon != null) {
      weather.fetch(zone.lat!, zone.lon!);
    }
  });

  AdService().initialize();

  // Coordinator: whenever weather or garden changes, recompute the set of
  // contextual warnings (frost / heatwave / dry spell). Cheap — at worst a
  // handful of cancel + schedule calls into the local notifications plugin.
  void refreshWarnings() {
    notifications.refreshContextualWarnings(
      forecast: weather.forecast,
      garden: garden.plants,
      plantLookup: db.byId,
      rainLast14d: weather.rainLast14d,
    );
  }

  // Coordinator: whenever the garden changes, redrive the per-plant
  // lifecycle notifications with dedup-by-species. Without this, a user
  // with two ruccola rows (one planerad, one utplanterad) would get
  // both "direktså" and "skörda" pushes on the same morning. The async
  // call handles its own scheduling on the platform side; no need to
  // block UI on completion.
  //
  // Tracks the previous garden-plant-id set across listener fires so
  // we can detect deletions — rescheduleAllForGarden only cancels for
  // plants still present, so a row that was deleted would otherwise
  // leak its lifecycle notifications until the iOS 64-pending-limit
  // shuffled them out.
  final previousGardenPlantIds = <String>{};
  Future<void> reschedulePlantLifecycles() async {
    // Pre-step: any plant that disappeared since the last fire was
    // deleted by the user. rescheduleAllForGarden no longer sees it
    // and would leave its notifications scheduled — cancel them
    // explicitly here.
    final currentIds = garden.plants.map((gp) => gp.id).toSet();
    final removed = previousGardenPlantIds.difference(currentIds);
    for (final id in removed) {
      await notifications.cancelForGardenPlant(id);
    }
    previousGardenPlantIds
      ..clear()
      ..addAll(currentIds);


    // Defensive cleanup for users on older builds: any wishlist row
    // whose species is already in the garden duplicates the garden's
    // own reminders and produces two "plantera ut X" notifications on
    // the same morning. Prune those before scheduling — but only when
    // the wishlist row belongs to the same garden as the matching
    // plant; balkong-paprika in garden A must not nuke a paprika
    // wishlist row in garden B.
    final byGardenSpecies = <String, Set<String>>{};
    for (final gp in garden.plants) {
      final gid = gp.gardenId;
      if (gid == null) continue;
      byGardenSpecies.putIfAbsent(gid, () => <String>{}).add(gp.plantId);
    }
    for (final w in season.allItems.toList()) {
      final gid = w.gardenId;
      if (gid == null) continue;
      if (byGardenSpecies[gid]?.contains(w.plantId) ?? false) {
        await notifications.cancelForWishlist(w.id);
        await season.remove(w.id);
      }
    }

    final updated = await notifications.rescheduleAllForGarden(
      garden: garden.plants,
      plantLookup: db.byId,
      zone: zone.zone,
    );
    // Persist any auto-transitions (e.g. utplanterad → skordeklar when
    // the harvest window opened during the time the app was closed).
    for (var i = 0; i < updated.length; i++) {
      final before = garden.plants.firstWhere(
        (gp) => gp.id == updated[i].id,
        orElse: () => updated[i],
      );
      if (before.status != updated[i].status) {
        await garden.update(updated[i]);
      }
    }
    // Roll up CareTasks + monthly chores into a single morning digest
    // per month — keeps the user from drowning in 100+ pings/year.
    await notifications.scheduleCareDigest(
      garden: garden.plants,
      plantLookup: db.byId,
      chores: chores.chores,
    );
  }

  weather.addListener(refreshWarnings);
  garden.addListener(refreshWarnings);
  garden.addListener(reschedulePlantLifecycles);

  // Re-schedule everything when notification settings change. This
  // catches the morning-hour picker in Settings — without this listener
  // the user picks 07:00, but all already-scheduled reminders keep
  // firing at the old hour until they get re-generated for other
  // reasons (garden edit, weather refresh).
  notifications.addListener(() {
    reschedulePlantLifecycles();
    refreshWarnings();
  });

  // Initial run on cold start — picks up auto-transitions from time
  // the app was closed and dedupes existing schedules.
  reschedulePlantLifecycles();

  // Seasonal "peak-intent"-pushar för svenska hobby-odlare. Idempotent —
  // varje cold start upsertar fönstret för innevarande + nästa år.
  // Cost: 0 (gratis kanal). Driver retention och konvertering under
  // feb-april peak-säsong utan att kräva användarinmatning.
  notifications.scheduleSeasonalCampaign(year: DateTime.now().year);

  runApp(PlanteraApp(
    premium: premium,
    zone: zone,
    db: db,
    garden: garden,
    harvest: harvest,
    weather: weather,
    notifications: notifications,
    ui: ui,
    season: season,
    chores: chores,
    pests: pests,
    tasks: tasks,
  ));

  _requestAttAndInitFacebook();
}

Future<void> _requestAttAndInitFacebook() async {
  if (kIsWeb) return;
  if (!Platform.isIOS) return;
  try {
    // iPadOS 26+ silently no-ops requestTrackingAuthorization if the app
    // isn't fully foregrounded. Wait for AppLifecycleState.resumed
    // before showing the prompt — Sömnkoll was rejected on this exact
    // pattern in May 2026 and the fix is the resumed-wait + retry loop.
    await _waitUntilResumed();

    var status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // Even when resumed, the system can return notDetermined on the
      // first call right after launch. Retry with backoff before giving
      // up — usually one extra try is enough.
      for (var attempt = 0; attempt < 4; attempt++) {
        final delay = Duration(milliseconds: 600 + attempt * 600);
        await Future.delayed(delay);
        await _waitUntilResumed();
        final result =
            await AppTrackingTransparency.requestTrackingAuthorization();
        if (result != TrackingStatus.notDetermined) {
          status = result;
          break;
        }
      }
    }

    if (status == TrackingStatus.authorized) {
      final facebook = FacebookAppEvents();
      await facebook.logEvent(name: 'fb_mobile_activate_app');
    }
  } catch (e) {
    debugPrint('ATT/FB init failed: $e');
  }

  // Show App Open ad on cold start. Without this trigger the ad would
  // only fire on resume — but most sessions are cold starts, so the
  // ad rarely (or never) serves.
  if (!PremiumService().isPremium) {
    AdService().showAppOpenAdWhenReady();
  }
}

/// Waits until WidgetsBinding reports AppLifecycleState.resumed.
/// Returns immediately if already resumed; bails out after 5s as a
/// safety net so we don't deadlock if the lifecycle never fires.
Future<void> _waitUntilResumed() async {
  final binding = WidgetsBinding.instance;
  if (binding.lifecycleState == AppLifecycleState.resumed) return;
  final completer = Completer<void>();
  late final _AttLifecycleWatcher watcher;
  watcher = _AttLifecycleWatcher(() {
    if (!completer.isCompleted) completer.complete();
  });
  binding.addObserver(watcher);
  try {
    await completer.future
        .timeout(const Duration(seconds: 5), onTimeout: () {});
  } finally {
    binding.removeObserver(watcher);
  }
}

class _AttLifecycleWatcher with WidgetsBindingObserver {
  final VoidCallback onResumed;
  _AttLifecycleWatcher(this.onResumed);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) onResumed();
  }
}

class PlanteraApp extends StatelessWidget {
  final PremiumService premium;
  final ZoneService zone;
  final PlantDatabaseService db;
  final GardenService garden;
  final HarvestService harvest;
  final WeatherService weather;
  final NotificationService notifications;
  final UISettingsService ui;
  final SeasonPlannerService season;
  final MonthlyChoresService chores;
  final PestLibraryService pests;
  final TaskService tasks;

  const PlanteraApp({
    super.key,
    required this.premium,
    required this.zone,
    required this.db,
    required this.garden,
    required this.harvest,
    required this.weather,
    required this.notifications,
    required this.ui,
    required this.season,
    required this.chores,
    required this.pests,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: premium),
        ChangeNotifierProvider.value(value: zone),
        ChangeNotifierProvider.value(value: db),
        ChangeNotifierProvider.value(value: garden),
        ChangeNotifierProvider.value(value: harvest),
        ChangeNotifierProvider.value(value: weather),
        ChangeNotifierProvider.value(value: notifications),
        ChangeNotifierProvider.value(value: ui),
        ChangeNotifierProvider.value(value: season),
        ChangeNotifierProvider.value(value: chores),
        ChangeNotifierProvider.value(value: pests),
        ChangeNotifierProvider.value(value: tasks),
      ],
      child: MaterialApp(
        title: 'Plantera',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // Europe-first launch: Swedish + Nordic neighbours + major EU
        // languages + English variants for USA/UK/Canada. Greek for
        // the small Greek market we're testing into. iOS picks the
        // user's preferred locale automatically; falls back to en
        // when a system language has no ARB.
        supportedLocales: const [
          Locale('sv'),
          Locale('en'),
          Locale('nb'),
          Locale('da'),
          Locale('fi'),
          Locale('de'),
          Locale('fr'),
          Locale('es'),
          Locale('it'),
          Locale('el'),
        ],
        // No explicit `locale:` — let iOS pick based on user's
        // preferred languages. Removing the hard-coded sv-SE means
        // a German user actually sees German UI.
        builder: (ctx, child) {
          final ui = ctx.watch<UISettingsService>();
          final media = MediaQuery.of(ctx);
          // Resolved locale lives downstream of localizationsDelegates,
          // so we have to read it inside the MaterialApp builder rather
          // than at construction. Push it into NotificationService so
          // scheduled reminders fire in the user's language instead of
          // hardcoded Swedish.
          final resolved = Localizations.localeOf(ctx);
          notifications.setLocale(resolved.toLanguageTag());
          return MediaQuery(
            data: media.copyWith(
              textScaler: TextScaler.linear(
                  media.textScaler.scale(1.0) * ui.textScale),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: Consumer2<ZoneService, UISettingsService>(
          builder: (ctx, z, ui, _) {
            final hasLocation = z.lat != null || z.city != null;
            if (!hasLocation) return const OnboardingScreen();
            // First-run intro fires once after onboarding lands the
            // user with a real zone. The flag persists so we don't
            // reshow it on every cold start; the user can re-watch it
            // from Inställningar if they want a refresher.
            if (!ui.introShown) {
              return Builder(
                builder: (ctx2) => IntroScreen(
                  onDone: () {
                    // No-op: setIntroShown above flips ui.introShown
                    // which rebuilds this Consumer and lands us on
                    // MainShell. Provide an explicit pop in case the
                    // intro was reached via a Navigator.push.
                    if (Navigator.of(ctx2).canPop()) {
                      Navigator.of(ctx2).pop();
                    }
                  },
                ),
              );
            }
            return const MainShell();
          },
        ),
      ),
    );
  }
}
