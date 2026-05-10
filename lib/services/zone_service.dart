import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/swedish_zones.dart';
import 'garden_service.dart';

/// Façade over GardenService.activeGarden — exposes zone/city/lat/lon
/// for the *currently active* garden so existing widgets that read
/// `context.watch<ZoneService>().zone` keep working unchanged.
///
/// Pre-multi-garden ZoneService stored everything in SharedPreferences.
/// We keep that as a fallback path:
///   - first launch (before any garden exists, during onboarding)
///   - migration boundaries
/// Once a garden exists, all reads/writes route through GardenService.
class ZoneService extends ChangeNotifier {
  static const _zoneKey = 'user_zone';
  static const _cityKey = 'user_city';
  static const _latKey = 'user_lat';
  static const _lonKey = 'user_lon';

  final GardenService _garden;

  ZoneService([GardenService? garden])
      : _garden = garden ?? GardenService();

  int _legacyZone = 3;
  String? _legacyCity;
  double? _legacyLat;
  double? _legacyLon;

  bool _wired = false;

  /// Active garden's zone, or the legacy SharedPreferences fallback when
  /// no garden exists yet. The 99% case is "garden exists" — fallback
  /// is only used during the brief onboarding window before
  /// `setCoordinates`/`setCity` creates the first garden.
  int get zone => _garden.activeGarden?.zone ?? _legacyZone;
  String? get city => _garden.activeGarden?.city ?? _legacyCity;
  double? get lat => _garden.activeGarden?.lat ?? _legacyLat;
  double? get lon => _garden.activeGarden?.lon ?? _legacyLon;
  String get zoneLabel => 'Zon $zone';
  String get zoneDescription => SwedishZones.zoneDescription(zone);
  (int month, int day) get lastFrostDate => SwedishZones.lastFrostDate(zone);
  (int month, int day) get firstFrostDate => SwedishZones.firstFrostDate(zone);

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _legacyZone = prefs.getInt(_zoneKey) ?? 3;
    _legacyCity = prefs.getString(_cityKey);
    _legacyLat = prefs.getDouble(_latKey);
    _legacyLon = prefs.getDouble(_lonKey);
    if (!_wired) {
      _garden.addListener(notifyListeners);
      _wired = true;
    }
    notifyListeners();
  }

  Future<void> setZone(int zone) async {
    final clamped = zone.clamp(1, 8);
    final active = _garden.activeGarden;
    if (active != null) {
      await _garden.updateGarden(active.copyWith(zone: clamped));
    } else {
      _legacyZone = clamped;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_zoneKey, clamped);
    }
    notifyListeners();
  }

  Future<void> setCity(String cityName) async {
    final coords = SwedishZones.cityCoords[cityName];
    if (coords == null) return;
    final z = SwedishZones.zoneForLatitude(coords.$1);
    final active = _garden.activeGarden;
    if (active != null) {
      await _garden.updateGarden(active.copyWith(
        city: cityName,
        lat: coords.$1,
        lon: coords.$2,
        zone: z,
      ));
    } else {
      // No garden yet — store in legacy keys; the migration / first
      // GardenService.createGarden() will pick these up.
      _legacyCity = cityName;
      _legacyLat = coords.$1;
      _legacyLon = coords.$2;
      _legacyZone = z;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cityKey, cityName);
      await prefs.setDouble(_latKey, coords.$1);
      await prefs.setDouble(_lonKey, coords.$2);
      await prefs.setInt(_zoneKey, z);
    }
    notifyListeners();
  }

  Future<void> setCoordinates(double lat, double lon, {String? name}) async {
    final z = SwedishZones.zoneForLatitude(lat);
    final active = _garden.activeGarden;
    if (active != null) {
      await _garden.updateGarden(active.copyWith(
        lat: lat,
        lon: lon,
        city: name ?? active.city,
        zone: z,
      ));
    } else {
      _legacyLat = lat;
      _legacyLon = lon;
      _legacyCity = name;
      _legacyZone = z;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, lat);
      await prefs.setDouble(_lonKey, lon);
      await prefs.setInt(_zoneKey, z);
      if (name != null) await prefs.setString(_cityKey, name);
    }
    notifyListeners();
  }

  /// Called by onboarding once the user has picked a zone/city/coords
  /// AND no garden exists yet. Creates the first "Min trädgård" using
  /// the legacy values that setCity/setCoordinates just wrote.
  Future<void> ensureFirstGarden() async {
    if (_garden.activeGarden != null) return;
    await _garden.createGarden(
      name: _legacyCity != null ? 'Min trädgård' : 'Min trädgård',
      emoji: '🌿',
      lat: _legacyLat,
      lon: _legacyLon,
      city: _legacyCity,
      zone: _legacyZone,
    );
  }
}
