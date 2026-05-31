import 'dart:convert';

import 'package:http/http.dart' as http;

/// One geocoded place — city, town or village — from Open-Meteo's
/// geocoding API. The same shape works regardless of country, which
/// is the whole point of switching away from the hard-coded Swedish
/// city list during onboarding.
class GeocodedPlace {
  final String name;
  final String? admin1; // state / region
  final String? country;
  final String? countryCode;
  final double lat;
  final double lon;
  final int? populationEstimate;

  const GeocodedPlace({
    required this.name,
    required this.admin1,
    required this.country,
    required this.countryCode,
    required this.lat,
    required this.lon,
    required this.populationEstimate,
  });

  /// Human-readable single-line description used in result lists.
  ///   "Berlin, Berlin, Germany"
  ///   "Sydney, New South Wales, Australia"
  String get displayLine {
    final parts = <String>[
      name,
      if (admin1 != null && admin1!.isNotEmpty && admin1 != name) admin1!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }
}

/// Thin wrapper around Open-Meteo's free geocoding endpoint. No API
/// key required, no rate-limit handshake — fine for the low-volume
/// city-search use case (one search per onboarding, occasional edits).
class GeocodingService {
  static const _base = 'https://geocoding-api.open-meteo.com/v1/search';

  /// Search cities by partial name. Returns up to [count] results sorted
  /// by relevance (Open-Meteo's own ranking — typically population +
  /// name-match weight). Returns empty list on network failure rather
  /// than throwing, so the calling UI can degrade gracefully.
  static Future<List<GeocodedPlace>> search(
    String query, {
    int count = 8,
    String language = 'en',
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];
    final uri = Uri.parse(_base).replace(queryParameters: {
      'name': trimmed,
      'count': '$count',
      'language': language,
      'format': 'json',
    });
    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) return const [];
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? const [];
      return results.map((r) {
        final m = r as Map<String, dynamic>;
        return GeocodedPlace(
          name: m['name'] as String? ?? '?',
          admin1: m['admin1'] as String?,
          country: m['country'] as String?,
          countryCode: m['country_code'] as String?,
          lat: (m['latitude'] as num?)?.toDouble() ?? 0,
          lon: (m['longitude'] as num?)?.toDouble() ?? 0,
          populationEstimate: (m['population'] as num?)?.toInt(),
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }
}
