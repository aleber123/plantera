class AppConstants {
  /// Bumped manually with each release. Surfaces in the feedback email
  /// signature so user reports come tagged with the version they're on.
  static const String appVersion = '1.5.0';

  static const String amazonAffiliateTag = 'alexanderbe05-21';

  static const String privacyPolicyUrl =
      'https://aleber123.github.io/plantera/privacy.html';
  static const String termsOfUseUrl =
      'https://aleber123.github.io/plantera/terms.html';
  static const String supportUrl =
      'https://aleber123.github.io/plantera/support.html';
  static const String supportEmail = 'support@alexanderbergqvist.com';

  static const String smhiPointForecastBase =
      'https://opendata-download-metfcst.smhi.se/api/category/snow1g/version/1/geotype/point';

  /// Open-Meteo forecast endpoint with `past_days` — used for historical
  /// precipitation. SMHI's `snow1g` is forecast-only; for "har det regnat
  /// senaste 14 dagar?" we need observation/reanalysis data. Open-Meteo
  /// merges archive + forecast in one call so we get fresh totals without
  /// the 2-5 day archive lag.
  static const String openMeteoForecastBase =
      'https://api.open-meteo.com/v1/forecast';

  static String openMeteoPastRainUrl(double lat, double lon,
      {int pastDays = 14}) {
    final latS = lat.toStringAsFixed(4);
    final lonS = lon.toStringAsFixed(4);
    return '$openMeteoForecastBase?latitude=$latS&longitude=$lonS'
        '&past_days=$pastDays&forecast_days=1'
        '&daily=precipitation_sum,temperature_2m_mean,'
        'temperature_2m_max,temperature_2m_min'
        '&timezone=auto';
  }

  /// 10-day daily forecast from Open-Meteo. Used as the global fallback
  /// when SMHI is unavailable (outside Nordic + N-Europe coverage box).
  static String openMeteoForecastUrl(double lat, double lon) {
    final latS = lat.toStringAsFixed(4);
    final lonS = lon.toStringAsFixed(4);
    return '$openMeteoForecastBase?latitude=$latS&longitude=$lonS'
        '&forecast_days=10'
        '&daily=temperature_2m_max,temperature_2m_min,'
        'precipitation_sum,weathercode'
        '&timezone=auto';
  }

  static String amazonUrl(String query) {
    final q = Uri.encodeComponent(query);
    return 'https://www.amazon.se/s?k=$q&tag=$amazonAffiliateTag';
  }

  static String smhiForecastUrl(double lat, double lon) {
    // SMHI PMP3g/snow1g endpoints expect 6 decimals of precision —
    // 4 decimals occasionally returned 404 at tile boundaries.
    final latS = lat.toStringAsFixed(6);
    final lonS = lon.toStringAsFixed(6);
    return '$smhiPointForecastBase/lon/$lonS/lat/$latS/data.json';
  }

  static const List<String> monthNamesSv = [
    '',
    'januari',
    'februari',
    'mars',
    'april',
    'maj',
    'juni',
    'juli',
    'augusti',
    'september',
    'oktober',
    'november',
    'december',
  ];

  static const List<String> monthShortSv = [
    '',
    'jan',
    'feb',
    'mar',
    'apr',
    'maj',
    'jun',
    'jul',
    'aug',
    'sep',
    'okt',
    'nov',
    'dec',
  ];
}
