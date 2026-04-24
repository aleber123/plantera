import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/swedish_zones.dart';

class ZoneService extends ChangeNotifier {
  static const _zoneKey = 'user_zone';
  static const _cityKey = 'user_city';
  static const _latKey = 'user_lat';
  static const _lonKey = 'user_lon';

  int _zone = 3;
  String? _city;
  double? _lat;
  double? _lon;

  int get zone => _zone;
  String? get city => _city;
  double? get lat => _lat;
  double? get lon => _lon;
  String get zoneLabel => 'Zon $_zone';
  String get zoneDescription => SwedishZones.zoneDescription(_zone);
  (int month, int day) get lastFrostDate => SwedishZones.lastFrostDate(_zone);
  (int month, int day) get firstFrostDate => SwedishZones.firstFrostDate(_zone);

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _zone = prefs.getInt(_zoneKey) ?? 3;
    _city = prefs.getString(_cityKey);
    _lat = prefs.getDouble(_latKey);
    _lon = prefs.getDouble(_lonKey);
    notifyListeners();
  }

  Future<void> setZone(int zone) async {
    _zone = zone.clamp(1, 8);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_zoneKey, _zone);
    notifyListeners();
  }

  Future<void> setCity(String cityName) async {
    final coords = SwedishZones.cityCoords[cityName];
    if (coords == null) return;
    _city = cityName;
    _lat = coords.$1;
    _lon = coords.$2;
    _zone = SwedishZones.zoneForLatitude(_lat!);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cityKey, _city!);
    await prefs.setDouble(_latKey, _lat!);
    await prefs.setDouble(_lonKey, _lon!);
    await prefs.setInt(_zoneKey, _zone);
    notifyListeners();
  }

  Future<void> setCoordinates(double lat, double lon, {String? name}) async {
    _lat = lat;
    _lon = lon;
    _city = name;
    _zone = SwedishZones.zoneForLatitude(lat);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lonKey, lon);
    await prefs.setInt(_zoneKey, _zone);
    if (name != null) await prefs.setString(_cityKey, name);
    notifyListeners();
  }
}
