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

  /// Coords of the forecast currently in [_forecast]. We compare against
  /// these on every fetch so switching gardens re-fetches even inside the
  /// 1h freshness window — otherwise the user sees the previous garden's
  /// frost for up to an hour and could lose sensitive plants.
  double? _lastLat;
  double? _lastLon;

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

  /// When the currently-shown [_forecast] was last successfully fetched.
  /// Lets the cards show "uppdaterad HH:MM" and detect stale/offline data
  /// after a failed refresh. Null until the first successful fetch.
  DateTime? get lastFetchedAt => _lastFetch;

  /// True when the most recent fetch failed but we're still showing an
  /// older forecast — i.e. the data on screen is stale/offline.
  bool get isStale => _error != null && _forecast.isNotEmpty;
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

  /// Next upcoming frost day, or null if none in forecast. We skip days
  /// before today so a cold afternoon whose night has already passed
  /// (mainly on the Open-Meteo fallback path, which can return today/past
  /// days) doesn't surface as an upcoming frost warning.
  WeatherDay? get nextFrostDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final d in _forecast) {
      final day = DateTime(d.date.year, d.date.month, d.date.day);
      if (day.isBefore(today)) continue;
      if (d.isFrostRisk) return d;
    }
    return null;
  }

  /// Tracks the in-flight fetch so callers waiting on the same coords
  /// piggy-back on it instead of being silently dropped. Fixes the
  /// pull-to-refresh bug where a force=true request was thrown away if
  /// an automatic fetch was already running.
  Future<void>? _inflight;
  /// Coords the in-flight fetch is running for. A caller for *different*
  /// coords (garden switch mid-fetch) must not piggy-back on it, else it
  /// would silently get the other garden's data.
  double? _inflightLat;
  double? _inflightLon;

  /// Two coordinates are "the same garden" if they're within ~0.01° (~1km).
  /// Avoids re-fetching on float jitter while still re-fetching on a real
  /// garden switch.
  bool _coordsClose(double a, double b) => (a - b).abs() < 0.01;

  Future<void> fetch(double lat, double lon, {bool force = false}) async {
    final now = DateTime.now();
    // Only honour the 1h freshness window when the request is for the
    // same coords as the cached forecast. Switching gardens (different
    // lat/lon) must always re-fetch, otherwise we'd show the previous
    // garden's frost — even without the caller passing force:true.
    final sameCoords = _lastLat != null &&
        _coordsClose(_lastLat!, lat) &&
        _coordsClose(_lastLon!, lon);
    if (!force && sameCoords && _lastFetch != null && _forecast.isNotEmpty) {
      if (now.difference(_lastFetch!) < const Duration(hours: 1)) return;
    }
    // If something is already fetching the same garden, callers wait for
    // it (and still get fresh data). A caller for different coords must
    // start its own fetch so a garden switch isn't served stale data.
    final pending = _inflight;
    if (pending != null &&
        _inflightLat != null &&
        _coordsClose(_inflightLat!, lat) &&
        _coordsClose(_inflightLon!, lon)) {
      return pending;
    }
    final completer = _runFetch(lat, lon, now);
    _inflight = completer;
    _inflightLat = lat;
    _inflightLon = lon;
    try {
      await completer;
    } finally {
      _inflight = null;
      _inflightLat = null;
      _inflightLon = null;
    }
  }

  Future<void> _runFetch(double lat, double lon, DateTime now) async {
    _loading = true;
    _error = null;
    notifyListeners();

    // SMHI covers the Nordics + parts of northern Europe (officially
    // lat 52-71, lon -9 to 38). Outside that box we fall back to
    // Open-Meteo's daily forecast which is global. We also fall back
    // when SMHI fails for any reason — the user shouldn't see "Väder
    // ej tillgängligt" just because they're in Spain.
    final inSmhiCoverage =
        lat >= 52 && lat <= 71 && lon >= -9 && lon <= 38;
    var fetched = false;
    if (inSmhiCoverage) {
      try {
        final uri = Uri.parse(AppConstants.smhiForecastUrl(lat, lon));
        final resp =
            await http.get(uri).timeout(const Duration(seconds: 15));
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          _forecast = _parseSmhi(data);
          _lastFetch = now;
          _lastLat = lat;
          _lastLon = lon;
          fetched = true;
        } else {
          debugPrint('SMHI HTTP ${resp.statusCode}; trying Open-Meteo');
        }
      } catch (e) {
        debugPrint('SMHI fetch failed ($e); trying Open-Meteo');
      }
    }

    if (!fetched) {
      try {
        final uri = Uri.parse(AppConstants.openMeteoForecastUrl(lat, lon));
        final resp =
            await http.get(uri).timeout(const Duration(seconds: 15));
        if (resp.statusCode != 200) {
          throw Exception('Open-Meteo HTTP ${resp.statusCode}');
        }
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        _forecast = _parseOpenMeteo(data);
        _lastFetch = now;
        _lastLat = lat;
        _lastLon = lon;
      } catch (e) {
        _error = e.toString();
        debugPrint('Open-Meteo fetch failed: $e');
      }
    }

    _loading = false;
    notifyListeners();
    // Historical rain is independent of the forecast: a failure here
    // shouldn't blank the forecast section.
    _fetchHistoricalRain(lat, lon);
  }

  /// Parses Open-Meteo daily forecast into the same WeatherDay shape
  /// as SMHI. Open-Meteo's `weathercode` differs from SMHI's symbol
  /// integers — we map it to the closest SMHI equivalent so the
  /// existing icon-lookup keeps working.
  List<WeatherDay> _parseOpenMeteo(Map<String, dynamic> data) {
    final daily = data['daily'] as Map<String, dynamic>?;
    if (daily == null) return [];
    final times = (daily['time'] as List?)?.cast<String>() ?? const [];
    final maxes = (daily['temperature_2m_max'] as List?) ?? const [];
    final mins = (daily['temperature_2m_min'] as List?) ?? const [];
    final codes = (daily['weathercode'] as List?) ?? const [];
    final precs = (daily['precipitation_sum'] as List?) ?? const [];
    final out = <WeatherDay>[];
    for (var i = 0; i < times.length; i++) {
      final date = DateTime.parse(times[i]);
      final mx = i < maxes.length ? (maxes[i] as num?)?.toDouble() : null;
      final mn = i < mins.length ? (mins[i] as num?)?.toDouble() : null;
      final wmo = i < codes.length ? (codes[i] as num?)?.toInt() ?? 0 : 0;
      final precip =
          i < precs.length ? (precs[i] as num?)?.toDouble() ?? 0 : 0.0;
      final smhiSymbol = _wmoToSmhiSymbol(wmo);
      out.add(WeatherDay(
        date: date,
        maxTempC: mx ?? 0,
        minTempC: mn ?? 0,
        precipitationMm: precip,
        windSpeedMs: 0, // Open-Meteo can return wind, but we don't
        // surface it in the UI — keep the request narrow.
        symbolDescription: _smhiSymbolText(smhiSymbol),
        smhiSymbolCode: smhiSymbol,
      ));
    }
    return out;
  }

  /// Maps WMO weather codes (Open-Meteo) → closest SMHI Wsymb2 code
  /// so the existing icon lookup keeps working. Reference:
  ///   https://open-meteo.com/en/docs (weathercode table)
  ///   https://opendata.smhi.se/apidocs/metfcst/parameters.html
  int _wmoToSmhiSymbol(int wmo) {
    if (wmo == 0) return 1; // clear
    if (wmo <= 2) return 2; // mostly clear / partly cloudy
    if (wmo <= 3) return 4; // overcast
    if (wmo == 45 || wmo == 48) return 7; // fog
    if (wmo >= 51 && wmo <= 57) return 9; // drizzle
    if (wmo >= 61 && wmo <= 65) return 10; // rain
    if (wmo >= 66 && wmo <= 67) return 12; // freezing rain
    if (wmo >= 71 && wmo <= 77) return 15; // snow
    if (wmo >= 80 && wmo <= 82) return 18; // rain showers
    if (wmo >= 85 && wmo <= 86) return 21; // snow showers
    if (wmo == 95) return 11; // thunderstorm
    if (wmo >= 96 && wmo <= 99) return 11; // thunderstorm w hail
    return 4; // unknown → overcast
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
      // Derive "today" from the API's own day buckets, not the device
      // clock: with timezone=auto the buckets are in the *garden's*
      // timezone, so a device in another timezone would otherwise skew
      // the boundary and drop/include the wrong day. The request uses
      // forecast_days=1, so the last time entry is the garden-local
      // today and every earlier entry is strictly in the past.
      final todayStr = times.isNotEmpty ? times.last : '';
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
