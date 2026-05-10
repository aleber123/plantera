import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../services/weather_service.dart';
import '../services/zone_service.dart';
import '../utils/swedish_zones.dart';
import '../utils/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _locating = false;

  Future<void> _useGps() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _locating = true);
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) throw l10n.onboardingErrorLocationServicesOff;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        throw l10n.onboardingErrorLocationDenied;
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      await context
          .read<ZoneService>()
          .setCoordinates(pos.latitude, pos.longitude);
      await _finish();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickCity(String city) async {
    await context.read<ZoneService>().setCity(city);
    await _finish();
  }

  Future<void> _finish() async {
    final zone = context.read<ZoneService>();
    // Multi-garden: create the first "Min trädgård" using the picked
    // zone/coords. Idempotent — does nothing if a garden already
    // exists (e.g. user re-opened onboarding from settings).
    await zone.ensureFirstGarden();
    if (!mounted) return;
    if (zone.lat != null && zone.lon != null) {
      context.read<WeatherService>().fetch(zone.lat!, zone.lon!);
    }
    await context.read<NotificationService>().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cities = SwedishZones.cityCoords.keys.toList()..sort();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('🌱',
                  style: TextStyle(fontSize: 64),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(l10n.onboardingWelcome,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                l10n.onboardingBody,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _locating ? null : _useGps,
                  icon: const Icon(Icons.my_location),
                  label: Text(_locating
                      ? l10n.onboardingLocating
                      : l10n.onboardingUseGps),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text(l10n.onboardingOrPickCity)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (_, i) {
                    final c = cities[i];
                    final coords = SwedishZones.cityCoords[c]!;
                    final z = SwedishZones.zoneForLatitude(coords.$1);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryGreen,
                        child: Text('$z',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(c),
                      subtitle:
                          Text(l10n.onboardingZoneSubtitle(z.toString())),
                      onTap: () => _pickCity(c),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
