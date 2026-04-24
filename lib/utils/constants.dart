class AppConstants {
  static const String amazonAffiliateTag = 'alexanderbe05-21';

  static const String privacyPolicyUrl =
      'https://aleber123.github.io/plantera-docs/privacy.html';
  static const String termsOfUseUrl =
      'https://aleber123.github.io/plantera-docs/terms.html';
  static const String supportUrl =
      'https://aleber123.github.io/plantera-docs/support.html';
  static const String supportEmail = 'support@alexanderbergqvist.com';

  static const String smhiPointForecastBase =
      'https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point';

  static String amazonUrl(String query) {
    final q = Uri.encodeComponent(query);
    return 'https://www.amazon.se/s?k=$q&tag=$amazonAffiliateTag';
  }

  static String smhiForecastUrl(double lat, double lon) {
    final latS = lat.toStringAsFixed(4);
    final lonS = lon.toStringAsFixed(4);
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
