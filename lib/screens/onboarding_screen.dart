import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/geocoding_service.dart';
import '../services/notification_service.dart';
import '../services/weather_service.dart';
import '../services/zone_service.dart';
import '../utils/climate_zones.dart';
import '../utils/swedish_zones.dart';
import '../utils/theme.dart';

/// Onboarding flow:
///   1-3 → value-prop slides (what does the app actually do for me?)
///   4   → pick zone (existing GPS / city picker)
///
/// Reason for the slides: before the rewrite, the user opened the app
/// and was immediately asked for their location — no idea why or what
/// they'd get in return. App Store reviewers compared us unfavorably
/// to PicturedThis/Planta which lead with a clear "scan a plant"
/// promise. These slides give an equivalent up-front value prop for
/// the timing/reminders niche we own.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtl = PageController();
  int _page = 0;
  static const _slideCount = 3;
  static const _totalPages = _slideCount + 1;

  @override
  void dispose() {
    _pageCtl.dispose();
    super.dispose();
  }

  void _skipToZonePicker() {
    _pageCtl.animateToPage(
      _slideCount,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_page < _slideCount) {
      _pageCtl.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageCtl,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _ValueSlide(
                    emoji: '📅',
                    accent: AppTheme.leafGreen,
                    icon: Icons.event_available,
                    title: l10n.onboardingSlide1Title,
                    body: l10n.onboardingSlide1Body,
                  ),
                  _ValueSlide(
                    emoji: '❄️',
                    accent: AppTheme.frostBlue,
                    icon: Icons.severe_cold,
                    title: l10n.onboardingSlide2Title,
                    body: l10n.onboardingSlide2Body,
                  ),
                  _ValueSlide(
                    emoji: '🌱',
                    accent: AppTheme.accentGreen,
                    icon: Icons.spa,
                    title: l10n.onboardingSlide3Title,
                    body: l10n.onboardingSlide3Body,
                  ),
                  _ZonePickerPage(onPicked: () async {
                    // ZonePickerPage finishes; nothing further here —
                    // the route will be replaced by the main shell as
                    // soon as ZoneService notifies its listeners.
                  }),
                ],
              ),
            ),
            _OnboardingFooter(
              page: _page,
              totalPages: _totalPages,
              onSkip: _page < _slideCount ? _skipToZonePicker : null,
              onNext: _page < _slideCount ? _next : null,
              nextLabel: _page == _slideCount - 1
                  ? l10n.onboardingFooterStart
                  : l10n.onboardingFooterNext,
              skipLabel: l10n.onboardingFooterSkip,
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueSlide extends StatelessWidget {
  final String emoji;
  final IconData icon;
  final Color accent;
  final String title;
  final String body;
  const _ValueSlide({
    required this.emoji,
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Color + icon + emoji together — color alone never carries
          // meaning here (user is color blind).
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 72, color: accent),
                Positioned(
                  bottom: 14,
                  right: 18,
                  child: Text(emoji, style: const TextStyle(fontSize: 38)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  final int page;
  final int totalPages;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;
  final String nextLabel;
  final String skipLabel;
  const _OnboardingFooter({
    required this.page,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
    required this.nextLabel,
    required this.skipLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (i) {
              final active = i == page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppTheme.primaryGreen
                      : AppTheme.primaryGreen.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          if (onNext != null)
            Row(
              children: [
                TextButton(
                  onPressed: onSkip,
                  child: Text(skipLabel),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                  ),
                  child: Text(nextLabel),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ZonePickerPage extends StatefulWidget {
  final Future<void> Function() onPicked;
  const _ZonePickerPage({required this.onPicked});

  @override
  State<_ZonePickerPage> createState() => _ZonePickerPageState();
}

class _ZonePickerPageState extends State<_ZonePickerPage> {
  bool _locating = false;
  final _searchCtl = TextEditingController();
  Timer? _debounce;
  List<GeocodedPlace> _searchResults = const [];
  bool _searching = false;
  bool _searchNetworkError = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtl.dispose();
    super.dispose();
  }

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
      // Cap the GPS lookup — without a timeLimit the platform can wait
      // indefinitely for a fix (e.g. indoors), leaving the spinner stuck.
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      await context
          .read<ZoneService>()
          .setCoordinates(pos.latitude, pos.longitude);
      await _finish();
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Kunde inte hitta din position — välj en stad i listan istället.'),
          ),
        );
      }
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

  Future<void> _pickSwedishCity(String city) async {
    await context.read<ZoneService>().setCity(city);
    await _finish();
  }

  Future<void> _pickGeocoded(GeocodedPlace place) async {
    final zone = context.read<ZoneService>();
    await zone.setCoordinates(place.lat, place.lon, name: place.name);
    await _finish();
  }

  Future<void> _finish() async {
    final zone = context.read<ZoneService>();
    await zone.ensureFirstGarden();
    if (!mounted) return;
    if (zone.lat != null && zone.lon != null) {
      context.read<WeatherService>().fetch(zone.lat!, zone.lon!);
    }
    await context.read<NotificationService>().requestPermissions();
    await widget.onPicked();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    // Capture the active locale so place names come back localised
    // (e.g. "Köpenhamn" rather than "Copenhagen") instead of anglicised.
    final lang = Localizations.localeOf(context).languageCode;
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      if (value.trim().length < 2) {
        setState(() {
          _searchResults = const [];
          _searchNetworkError = false;
        });
        return;
      }
      setState(() => _searching = true);
      final result = await GeocodingService.search(value, language: lang);
      if (!mounted) return;
      setState(() {
        _searchResults = result.places;
        _searchNetworkError = result.networkError;
        _searching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final swedishCities = SwedishZones.cityCoords.keys.toList()..sort();
    final hasSearch = _searchCtl.text.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('📍',
              style: TextStyle(fontSize: 56), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l10n.onboardingWelcome,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            l10n.onboardingBody,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 18),
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
          const SizedBox(height: 14),
          Center(child: Text(l10n.onboardingOrPickCity)),
          const SizedBox(height: 10),
          TextField(
            controller: _searchCtl,
            onChanged: (v) {
              setState(() {});
              _onSearchChanged(v);
            },
            decoration: InputDecoration(
              hintText: 'Sök stad…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: hasSearch
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtl.clear();
                        setState(() {
                          _searchResults = const [];
                          _searchNetworkError = false;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _searching
                ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2))
                : hasSearch
                    ? _SearchResultsList(
                        results: _searchResults,
                        networkError: _searchNetworkError,
                        onPick: _pickGeocoded,
                      )
                    : _SwedishCityList(
                        cities: swedishCities,
                        onPick: _pickSwedishCity,
                        zoneSubtitle: l10n.onboardingZoneSubtitle,
                      ),
          ),
        ],
      ),
    );
  }
}

class _SwedishCityList extends StatelessWidget {
  final List<String> cities;
  final void Function(String) onPick;
  final String Function(String) zoneSubtitle;
  const _SwedishCityList({
    required this.cities,
    required this.onPick,
    required this.zoneSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (_, i) {
        final c = cities[i];
        final coords = SwedishZones.cityCoords[c]!;
        final z = SwedishZones.zoneForLatitude(coords.$1);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryGreen,
            child: Text('$z', style: const TextStyle(color: Colors.white)),
          ),
          title: Text(c),
          subtitle: Text(zoneSubtitle(z.toString())),
          onTap: () => onPick(c),
        );
      },
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final List<GeocodedPlace> results;
  final bool networkError;
  final void Function(GeocodedPlace) onPick;
  const _SearchResultsList({
    required this.results,
    required this.networkError,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      // Distinguish "search ran, nothing matched" from "couldn't reach
      // the geocoder" — telling an offline user to try another spelling
      // is misleading.
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            networkError
                ? 'Ingen anslutning — kontrollera internet och försök igen.'
                : 'Inga städer matchar — prova en annan stavning.',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final r = results[i];
        final profile = ClimateProfile.fromCoordinates(r.lat, r.lon);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryGreen,
            child: Text(
              '${profile.usdaZone.number}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800),
            ),
          ),
          title: Text(r.name,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(
            '${[
              r.admin1,
              r.country,
            ].whereType<String>().where((s) => s.isNotEmpty).join(', ')} · ${profile.usdaZone.label}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => onPick(r),
        );
      },
    );
  }
}
