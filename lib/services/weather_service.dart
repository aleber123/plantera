import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';

/// Fetches weather from SMHI Open Data snow1g point-forecast API.
/// (Replaces deprecated PMP3gv2 which was retired 2026-03-31.)
/// SMHI returns hourly data for ~10 days. We reduce to daily min/max.
class WeatherService extends ChangeNotifier {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  List<WeatherDay> _forecast = [];
  DateTime? _lastFetch;
  bool _loading = false;
  String? _error;

  /// Total observed precipitation (mm) over the last 14 days from
  /// Open-Meteo. Null until [_fetchHistoricalRain] succeeds. Used to drive
  /// the "torka pågår"-warning that the SMHI forecast alone can't see —
  /// SMHI only knows the future. Combined with the next-7-day forecast
  /// it gives a much stronger drought signal.
  double? _rainLast14d;

  /// Mean daily temperature averaged over the last 14 days. Used by
  /// the premium "Klimatkort"-feature on Hem. Combined with [_gddLast14d]
  /// it gives the user a sense of how this season compares — many
  /// gardeners use Growing Degree Days to time succession sowing,
  /// flowering and harvest.
  double? _avgTempLast14d;
  double? _maxTempLast14d;
  double? _minTempLast14d;
  /// Accumulated Growing Degree Days last 14 days, base 10°C.
  /// GDD per day = max(0, (Tmax + Tmin) / 2 - 10). Standard kitchen-
  /// garden base; tomato/squash/peppers track maturity against this.
  double? _gddLast14d;

  List<WeatherDay> get forecast => List.unmodifiable(_forecast);
  bool get loading => _loading;
  String? get error => _error;
  double? get rainLast14d => _rainLast14d;
  double? get avgTempLast14d => _avgTempLast14d;
  double? get maxTempLast14d => _maxTempLast14d;
  double? get minTempLast14d => _minTempLast14d;
  double? get gddLast14d => _gddLast14d;

  /// Total expected precipitation (mm) for the next 7 forecast days.
  /// Computed lazily from [_forecast] so callers don't need to redo it.
  double get rainNext7d => _forecast
      .take(7)
      .fold<double>(0, (sum, d) => sum + d.precipitationMm);

  /// Next upcoming frost day, or null if none in forecast.
  WeatherDay? get nextFrostDay {
    for (final d in _forecast) {
      if (d.isFrostRisk) return d;
    }
    return null;
  }

  /// Tracks the in-flight fetch so callers waiting on the same coords
  /// piggy-back on it instead of being silently dropped. Fixes the
  /// pull-to-refresh bug where a force=true request was thrown away if
  /// an automatic fetch was already running.
  Future<void>? _inflight;

  Future<void> fetch(double lat, double lon, {bool force = false}) async {
    final now = DateTime.now();
    if (!force && _lastFetch != null && _forecast.isNotEmpty) {
      if (now.difference(_lastFetch!) < const Duration(hours: 1)) return;
    }
    // If something is already fetching, force-callers wait for it (and
    // still get fresh data). Non-force callers piggy-back too.
    final pending = _inflight;
    if (pending != null) return pending;
    final completer = _runFetch(lat, lon, now);
    _inflight = completer;
    try {
      await completer;
    } finally {
      _inflight = null;
    }
  }

  Future<void> _runFetch(double lat, double lon, DateTime now) async {
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
    // Historical rain is independent of the forecast: a failure here
    // shouldn't blank the forecast section. Fire after the SMHI block
    // so the UI gets the (more important) forecast immediately and the
    // drought banner fills in once the second request lands.
    _fetchHistoricalRain(lat, lon);
  }

  /// Pulls observed precipitation for the last 14 days from Open-Meteo.
  /// Best-effort — if the network call fails the dryness banner just
  /// stays hidden, no user-facing error since the forecast still works.
  Future<void> _fetchHistoricalRain(double lat, double lon) async {
    try {
      final uri = Uri.parse(AppConstants.openMeteoPastRainUrl(lat, lon));
      final resp =
          await http.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode != 200) return;
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final daily = data['daily'] as Map<String, dynamic>?;
      if (daily == null) return;
      final times = (daily['time'] as List?)?.cast<String>() ?? const [];
      final sums = (daily['precipitation_sum'] as List?) ?? const [];
      final means =
          (daily['temperature_2m_mean'] as List?) ?? const [];
      final maxes =
          (daily['temperature_2m_max'] as List?) ?? const [];
      final mins = (daily['temperature_2m_min'] as List?) ?? const [];
      // Only sum days that are strictly in the past — Open-Meteo
      // returns one forecast day too which we exclude so today's
      // potentially-still-coming rain doesn't muddy the signal.
      final today = DateTime.now();
      final todayStr = '${today.year.toString().padLeft(4, '0')}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';
      double rainTotal = 0;
      double meanSum = 0;
      double maxSum = 0;
      double minSum = 0;
      double gddTotal = 0;
      var n = 0;
      for (var i = 0; i < times.length; i++) {
        if (times[i].compareTo(todayStr) >= 0) continue;
        final r = i < sums.length ? (sums[i] as num?)?.toDouble() : null;
        if (r != null) rainTotal += r;
        final mean =
            i < means.length ? (means[i] as num?)?.toDouble() : null;
        final mx = i < maxes.length ? (maxes[i] as num?)?.toDouble() : null;
        final mn = i < mins.length ? (mins[i] as num?)?.toDouble() : null;
        if (mean != null) meanSum += mean;
        if (mx != null) maxSum += mx;
        if (mn != null) minSum += mn;
        // Standard GDD formula, base 10°C — captures tomato/squash/
        // pepper maturity timing. Negative days clamp to 0.
        if (mx != null && mn != null) {
          final gdd = ((mx + mn) / 2 - 10);
          gddTotal += gdd > 0 ? gdd : 0;
        }
        n++;
      }
      _rainLast14d = rainTotal;
      if (n > 0) {
        _avgTempLast14d = meanSum / n;
        _maxTempLast14d = maxSum / n;
        _minTempLast14d = minSum / n;
        _gddLast14d = gddTotal;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Open-Meteo history failed: $e');
    }
  }

  List<WeatherDay> _parseSmhi(Map<String, dynamic> data) {
    final timeSeries = (data['timeSeries'] as List?) ?? [];
    final Map<String, List<Map<String, dynamic>>> byDay = {};

    for (final entry in timeSeries) {
      final e = entry as Map<String, dynamic>;
      final timeStr = e['time'] as String;
      final time = DateTime.parse(timeStr).toLocal();
      final key =
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
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
        final d = e['data'] as Map<String, dynamic>?;
        if (d == null) continue;
        final t = (d['air_temperature'] as num?)?.toDouble();
        if (t != null) {
          minT = (minT == null) ? t : (t < minT ? t : minT);
          maxT = (maxT == null) ? t : (t > maxT ? t : maxT);
        }
        final p = (d['precipitation_amount_mean'] as num?)?.toDouble() ??
            (d['precipitation_amount_mean_deterministic'] as num?)?.toDouble();
        if (p != null) precip += p;
        final w = (d['wind_speed'] as num?)?.toDouble();
        if (w != null && w > maxWind) maxWind = w;
        final s = (d['symbol_code'] as num?)?.toInt();
        if (s != null) symbol ??= s;
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
