import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/climate_zones.dart';
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

  /// Global climate profile derived from the current lat/lon. Returns
  /// null when no coordinates are set yet — callers should fall back
  /// to the Swedish zone-based behaviour in that case.
  ClimateProfile? get climate {
    final la = lat, lo = lon;
    if (la == null || lo == null) return null;
    return ClimateProfile.fromCoordinates(la, lo);
  }

  /// Region-appropriate zone label. Inside Sweden we show the local
  /// Swedish växtzon ("Zon 3"); outside we switch to the global USDA
  /// hardiness zone ("USDA 6") which is the international standard.
  String get zoneLabel {
    final c = climate;
    if (c == null || !c.isOutsideSweden) return 'Zon $zone';
    return c.usdaZone.label;
  }

  String get zoneDescription {
    final c = climate;
    if (c == null || !c.isOutsideSweden) {
      return SwedishZones.zoneDescription(zone);
    }
    // Approximate degrees-Celsius minimum for the USDA zone.
    final minC = c.usdaZone.minTempC.round();
    return '${c.usdaZone.label} – vintertemp typiskt ner till $minC°C';
  }

  /// Approximate last-frost date in the *active garden's* climate. In
  /// Sweden we read from SwedishZones; elsewhere we derive a rough
  /// date from latitude (frost recedes ~1 day per degree latitude as
  /// you go south). Caller can override via Settings.
  (int month, int day) get lastFrostDate {
    final c = climate;
    if (c == null || !c.isOutsideSweden) {
      return SwedishZones.lastFrostDate(zone);
    }
    return _lastFrostForClimate(c);
  }

  (int month, int day) get firstFrostDate {
    final c = climate;
    if (c == null || !c.isOutsideSweden) {
      return SwedishZones.firstFrostDate(zone);
    }
    return _firstFrostForClimate(c);
  }

  static (int, int) _lastFrostForClimate(ClimateProfile c) {
    // North-hemisphere baseline; the southern hemisphere swap is
    // handled by the season-shifter further down the stack.
    final absLat = c.latitude.abs();
    if (absLat < 25) return (1, 1); // no frost
    if (absLat < 35) return (3, 1);
    if (absLat < 40) return (4, 1);
    if (absLat < 45) return (4, 15);
    if (absLat < 50) return (5, 1);
    if (absLat < 55) return (5, 10);
    if (absLat < 60) return (5, 20);
    return (6, 5);
  }

  static (int, int) _firstFrostForClimate(ClimateProfile c) {
    final absLat = c.latitude.abs();
    if (absLat < 25) return (12, 31); // no frost
    if (absLat < 35) return (12, 1);
    if (absLat < 40) return (11, 1);
    if (absLat < 45) return (10, 20);
    if (absLat < 50) return (10, 1);
    if (absLat < 55) return (10, 15);
    if (absLat < 60) return (9, 25);
    return (9, 5);
  }

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
