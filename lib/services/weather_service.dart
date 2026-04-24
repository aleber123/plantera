import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';

/// Fetches weather from SMHI Open Data PMP3g point-forecast API.
/// SMHI returns hourly data for ~10 days. We reduce to daily min/max.
class WeatherService extends ChangeNotifier {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  List<WeatherDay> _forecast = [];
  DateTime? _lastFetch;
  bool _loading = false;
  String? _error;

  List<WeatherDay> get forecast => List.unmodifiable(_forecast);
  bool get loading => _loading;
  String? get error => _error;

  /// Next upcoming frost day, or null if none in forecast.
  WeatherDay? get nextFrostDay {
    for (final d in _forecast) {
      if (d.isFrostRisk) return d;
    }
    return null;
  }

  Future<void> fetch(double lat, double lon, {bool force = false}) async {
    if (_loading) return;
    final now = DateTime.now();
    if (!force && _lastFetch != null && _forecast.isNotEmpty) {
      if (now.difference(_lastFetch!) < const Duration(hours: 1)) return;
    }
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final uri = Uri.parse(AppConstants.smhiForecastUrl(lat, lon));
      final resp = await http.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) {
        throw Exception('SMHI HTTP ${resp.statusCode}');
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      _forecast = _parseSmhi(data);
      _lastFetch = now;
    } catch (e) {
      _error = e.toString();
      debugPrint('SMHI fetch failed: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<WeatherDay> _parseSmhi(Map<String, dynamic> data) {
    final timeSeries = (data['timeSeries'] as List?) ?? [];
    final Map<String, List<Map<String, dynamic>>> byDay = {};

    for (final entry in timeSeries) {
      final e = entry as Map<String, dynamic>;
      final validTimeStr = e['validTime'] as String;
      final validTime = DateTime.parse(validTimeStr).toLocal();
      final key =
          '${validTime.year}-${validTime.month.toString().padLeft(2, '0')}-${validTime.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => []);
      byDay[key]!.add(e);
    }

    final days = <WeatherDay>[];
    final sortedKeys = byDay.keys.toList()..sort();
    for (final key in sortedKeys) {
      final entries = byDay[key]!;
      double? minT;
      double? maxT;
      double precip = 0;
      double maxWind = 0;
      int? symbol;

      for (final e in entries) {
        final params = (e['parameters'] as List).cast<Map<String, dynamic>>();
        for (final p in params) {
          final name = p['name'] as String;
          final values = (p['values'] as List).cast<num>();
          if (values.isEmpty) continue;
          final v = values.first.toDouble();
          switch (name) {
            case 't':
              minT = (minT == null) ? v : (v < minT ? v : minT);
              maxT = (maxT == null) ? v : (v > maxT ? v : maxT);
              break;
            case 'pmean':
              precip += v;
              break;
            case 'ws':
              if (v > maxWind) maxWind = v;
              break;
            case 'Wsymb2':
              symbol ??= v.toInt();
              break;
          }
        }
      }

      if (minT == null || maxT == null) continue;
      final parts = key.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]),
          int.parse(parts[2]));
      days.add(WeatherDay(
        date: date,
        minTempC: minT,
        maxTempC: maxT,
        symbolDescription: _smhiSymbolText(symbol ?? 1),
        smhiSymbolCode: symbol ?? 1,
        precipitationMm: precip,
        windSpeedMs: maxWind,
      ));
    }

    return days.take(10).toList();
  }

  String _smhiSymbolText(int code) {
    return switch (code) {
      1 => 'Klart',
      2 => 'Mestadels klart',
      3 => 'Växlande molnighet',
      4 => 'Halvklart',
      5 => 'Molnigt',
      6 => 'Mulet',
      7 => 'Dimma',
      8 || 9 || 10 => 'Regnskurar',
      11 => 'Åska',
      12 || 13 || 14 => 'Snö-/regnblandat',
      15 || 16 || 17 => 'Snöbyar',
      18 || 19 || 20 => 'Regn',
      21 => 'Åska',
      22 || 23 || 24 => 'Snöblandat regn',
      25 || 26 || 27 => 'Snö',
      _ => 'Okänt väder',
    };
  }
}
