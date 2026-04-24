/// Swedish growth zones (Riksförbundet Svensk Trädgård). Approximate mapping
/// from latitude + elevation (we only use latitude here — close enough for
/// our purposes given users can manually override in Settings).
class SwedishZones {
  /// Returns the zone (1-8) for a given latitude.
  /// South Sweden = 1, Kiruna = 8. This is a simplified coastal approximation.
  static int zoneForLatitude(double lat) {
    if (lat < 56.0) return 1; // Skåne, Blekinge
    if (lat < 57.5) return 2; // Halland, Småland södra, Öland, Gotland
    if (lat < 58.8) return 3; // Småland norra, Västergötland, Östergötland
    if (lat < 60.0) return 4; // Stockholm, Södermanland, Uppland
    if (lat < 61.5) return 5; // Gästrikland, Dalarna södra
    if (lat < 63.5) return 6; // Hälsingland, Medelpad, Jämtland södra
    if (lat < 65.5) return 7; // Ångermanland, Västerbotten
    return 8; // Lappland
  }

  /// Approximate central coordinates for Swedish cities (fallback when GPS denied).
  static const Map<String, (double lat, double lon)> cityCoords = {
    'Stockholm': (59.3293, 18.0686),
    'Göteborg': (57.7089, 11.9746),
    'Malmö': (55.6050, 13.0038),
    'Uppsala': (59.8586, 17.6389),
    'Västerås': (59.6099, 16.5448),
    'Örebro': (59.2753, 15.2134),
    'Linköping': (58.4108, 15.6214),
    'Helsingborg': (56.0465, 12.6945),
    'Jönköping': (57.7826, 14.1618),
    'Norrköping': (58.5877, 16.1924),
    'Lund': (55.7047, 13.1910),
    'Umeå': (63.8258, 20.2630),
    'Gävle': (60.6749, 17.1413),
    'Borås': (57.7210, 12.9401),
    'Eskilstuna': (59.3712, 16.5097),
    'Sundsvall': (62.3908, 17.3069),
    'Halmstad': (56.6745, 12.8578),
    'Karlstad': (59.3793, 13.5036),
    'Växjö': (56.8777, 14.8091),
    'Luleå': (65.5848, 22.1547),
    'Kiruna': (67.8558, 20.2253),
    'Östersund': (63.1792, 14.6357),
    'Falun': (60.6065, 15.6355),
    'Visby': (57.6348, 18.2942),
    'Kalmar': (56.6616, 16.3616),
  };

  static String zoneDescription(int zone) {
    return switch (zone) {
      1 => 'Zon 1 – Skåne, sydkusten. Mildast klimat, längst odlingssäsong.',
      2 => 'Zon 2 – Halland, Småland södra, Öland, Gotland.',
      3 => 'Zon 3 – Västergötland, Östergötland, Småland norra.',
      4 => 'Zon 4 – Stockholm, Uppland, Södermanland.',
      5 => 'Zon 5 – Gästrikland, Dalarna södra. Kortare säsong.',
      6 => 'Zon 6 – Hälsingland, Jämtland södra.',
      7 => 'Zon 7 – Ångermanland, Västerbotten.',
      8 => 'Zon 8 – Lappland, norra Norrland. Kortast säsong.',
      _ => 'Okänd zon',
    };
  }

  /// Typical last frost date (approximate) for each zone.
  static (int month, int day) lastFrostDate(int zone) {
    return switch (zone) {
      1 => (4, 25),
      2 => (5, 5),
      3 => (5, 15),
      4 => (5, 20),
      5 => (5, 25),
      6 => (6, 1),
      7 => (6, 10),
      8 => (6, 20),
      _ => (5, 20),
    };
  }

  /// Typical first autumn frost date (approximate) for each zone.
  static (int month, int day) firstFrostDate(int zone) {
    return switch (zone) {
      1 => (10, 25),
      2 => (10, 15),
      3 => (10, 5),
      4 => (9, 25),
      5 => (9, 20),
      6 => (9, 10),
      7 => (9, 1),
      8 => (8, 25),
      _ => (9, 25),
    };
  }
}
