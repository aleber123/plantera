import 'dart:io' show Platform;
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/ad_service.dart';
import 'services/garden_service.dart';
import 'services/notification_service.dart';
import 'services/plant_database_service.dart';
import 'services/premium_service.dart';
import 'services/weather_service.dart';
import 'services/zone_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final premium = PremiumService();
  final zone = ZoneService();
  final db = PlantDatabaseService();
  final garden = GardenService();
  final weather = WeatherService();
  final notifications = NotificationService();

  await Future.wait([
    premium.initialize(),
    zone.initialize(),
    db.load(),
    garden.initialize(),
    notifications.initialize(),
  ]);

  if (zone.lat != null && zone.lon != null) {
    // Fire-and-forget – don't block app startup on network.
    weather.fetch(zone.lat!, zone.lon!);
  }

  AdService().initialize();

  runApp(PlanteraApp(
    premium: premium,
    zone: zone,
    db: db,
    garden: garden,
    weather: weather,
    notifications: notifications,
  ));

  _requestAttAndInitFacebook();
}

Future<void> _requestAttAndInitFacebook() async {
  if (kIsWeb) return;
  if (!Platform.isIOS) return;
  try {
    await Future.delayed(const Duration(seconds: 1));
    await AppTrackingTransparency.requestTrackingAuthorization();
    final facebook = FacebookAppEvents();
    await facebook.logEvent(name: 'fb_mobile_activate_app');
  } catch (e) {
    debugPrint('ATT/FB init failed: $e');
  }
}

class PlanteraApp extends StatelessWidget {
  final PremiumService premium;
  final ZoneService zone;
  final PlantDatabaseService db;
  final GardenService garden;
  final WeatherService weather;
  final NotificationService notifications;

  const PlanteraApp({
    super.key,
    required this.premium,
    required this.zone,
    required this.db,
    required this.garden,
    required this.weather,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: premium),
        ChangeNotifierProvider.value(value: zone),
        ChangeNotifierProvider.value(value: db),
        ChangeNotifierProvider.value(value: garden),
        ChangeNotifierProvider.value(value: weather),
        ChangeNotifierProvider.value(value: notifications),
      ],
      child: MaterialApp(
        title: 'Plantera',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('sv', 'SE'), Locale('en')],
        locale: const Locale('sv', 'SE'),
        home: Consumer<ZoneService>(
          builder: (ctx, z, _) {
            final hasLocation = z.lat != null || z.city != null;
            return hasLocation ? const MainShell() : const OnboardingScreen();
          },
        ),
      ),
    );
  }
}
