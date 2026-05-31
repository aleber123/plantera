/// Global climate-zone toolkit. Replaces (or augments) the Sweden-only
/// `SwedishZones` with classifications that work everywhere on Earth.
///
/// Three concepts:
///   1. [Hemisphere]   — north/south. South-of-equator inverts the
///                       gardening calendar by 6 months.
///   2. [UsdaZone]     — USDA Plant Hardiness Zones 1-13, the global
///                       standard for "how cold gets winter here".
///   3. [SwedishZone]  — kept as a Sweden-specific override since the
///                       database is calibrated to it. Cross-walked
///                       to USDA where possible.
///
/// We deliberately keep this latitude-only (no elevation, no proper
/// Köppen-Geiger map lookup). For an app the user can manually
/// override in Settings this is "good enough" — refining it would
/// require shipping a 12MB climate-raster file we don't actually need.
library;

enum Hemisphere {
  north,
  south;

  static Hemisphere forLatitude(double lat) =>
      lat >= 0 ? Hemisphere.north : Hemisphere.south;

  /// Months are shifted by 6 in the southern hemisphere — what the
  /// plant database calls "March" (a spring month for SE-calibrated
  /// data) becomes September for an Australian user. Used to flip
  /// every plant.json date field at read time.
  int shiftMonth(int month) {
    if (this == Hemisphere.north) return month;
    final shifted = ((month + 5) % 12) + 1;
    return shifted;
  }
}

/// USDA Plant Hardiness Zone — global standard. Zone 1 = -60°C minimum
/// winter low, Zone 13 = +21°C minimum (no frost ever). The plant
/// database stores hardiness as `kallighet_c` (lowest temp the plant
/// tolerates) which maps directly into a USDA zone via [minTempC].
enum UsdaZone {
  z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, z11, z12, z13;

  /// Approximate average annual minimum temperature for each zone.
  /// USDA defines 5°F (~2.8°C) increments; we round to whole °C for
  /// display purposes.
  double get minTempC {
    return switch (this) {
      UsdaZone.z1 => -51,
      UsdaZone.z2 => -45,
      UsdaZone.z3 => -40,
      UsdaZone.z4 => -34,
      UsdaZone.z5 => -29,
      UsdaZone.z6 => -23,
      UsdaZone.z7 => -18,
      UsdaZone.z8 => -12,
      UsdaZone.z9 => -7,
      UsdaZone.z10 => -1,
      UsdaZone.z11 => 4,
      UsdaZone.z12 => 10,
      UsdaZone.z13 => 16,
    };
  }

  String get label => switch (this) {
        UsdaZone.z1 => 'USDA 1',
        UsdaZone.z2 => 'USDA 2',
        UsdaZone.z3 => 'USDA 3',
        UsdaZone.z4 => 'USDA 4',
        UsdaZone.z5 => 'USDA 5',
        UsdaZone.z6 => 'USDA 6',
        UsdaZone.z7 => 'USDA 7',
        UsdaZone.z8 => 'USDA 8',
        UsdaZone.z9 => 'USDA 9',
        UsdaZone.z10 => 'USDA 10',
        UsdaZone.z11 => 'USDA 11',
        UsdaZone.z12 => 'USDA 12',
        UsdaZone.z13 => 'USDA 13',
      };

  int get number => index + 1;

  static UsdaZone fromNumber(int n) {
    final clamped = n.clamp(1, 13);
    return UsdaZone.values[clamped - 1];
  }

  /// Best-effort guess at a user's USDA zone from their coordinates.
  ///
  /// This uses **latitude-band approximation** — there are no proper
  /// gridded USDA maps for outside the US, so we fall back to a
  /// Northern-Hemisphere "general continental Europe / North America"
  /// model and mirror it for the Southern Hemisphere. The user can
  /// override manually in Settings.
  ///
  /// Coastal modifier: regions within 2° of a typical coastline are
  /// bumped up one zone since maritime climate moderates winter lows.
  /// We don't have coastline data so this is encoded as longitude bands
  /// roughly matching Atlantic + Pacific seaboards.
  static UsdaZone forCoordinates(double lat, double lon) {
    final absLat = lat.abs();

    // Equatorial belt ≈ no frost, USDA 11-13.
    if (absLat < 10) return UsdaZone.z13;
    if (absLat < 20) return UsdaZone.z12;
    if (absLat < 25) return UsdaZone.z11;
    if (absLat < 30) return UsdaZone.z10;

    // Subtropical → temperate. Coastal areas warmer than inland.
    final isCoastal = _isLikelyCoastal(lat, lon);
    if (absLat < 35) return isCoastal ? UsdaZone.z9 : UsdaZone.z8;
    if (absLat < 40) return isCoastal ? UsdaZone.z8 : UsdaZone.z7;
    if (absLat < 45) return isCoastal ? UsdaZone.z7 : UsdaZone.z6;
    if (absLat < 50) return isCoastal ? UsdaZone.z6 : UsdaZone.z5;

    // Continental Europe / Canada / Russia. The Gulf Stream keeps
    // western Europe ~2 zones warmer than the same latitude in central
    // Russia or Canada.
    final isGulfStream = lat >= 50 && lon >= -10 && lon <= 25;
    if (absLat < 55) return isGulfStream ? UsdaZone.z7 : UsdaZone.z5;
    if (absLat < 60) return isGulfStream ? UsdaZone.z6 : UsdaZone.z4;
    if (absLat < 63) return isGulfStream ? UsdaZone.z5 : UsdaZone.z3;
    if (absLat < 66) return isGulfStream ? UsdaZone.z4 : UsdaZone.z2;
    return UsdaZone.z1;
  }

  static bool _isLikelyCoastal(double lat, double lon) {
    // Very rough — west coasts of N. America (lon -130 to -115), east
    // coasts of N. America (lon -85 to -70), western Europe (lon -10
    // to 5), eastern Australia (lon 145-155), Mediterranean (lon -5
    // to 35, lat 30-45).
    if (lon >= -130 && lon <= -115) return true;
    if (lon >= -85 && lon <= -70) return true;
    if (lon >= -10 && lon <= 5) return true;
    if (lon >= 145 && lon <= 155) return true;
    if (lat.abs() >= 30 && lat.abs() <= 45 && lon >= -5 && lon <= 35) {
      return true;
    }
    return false;
  }
}

/// Cross-walk between Swedish växtzoner (1-8, with 1 = mildest) and
/// USDA hardiness zones (1-13, with higher = warmer). Approximate.
class ZoneCrosswalk {
  /// Swedish zone → typical USDA zone equivalent.
  static UsdaZone swedishToUsda(int swedishZone) {
    return switch (swedishZone) {
      1 => UsdaZone.z7, // Skåne — like coastal Belgium/Holland
      2 => UsdaZone.z7, // Halland/Småland S
      3 => UsdaZone.z6, // Mälardalen, our calibration baseline
      4 => UsdaZone.z6, // Stockholm
      5 => UsdaZone.z5, // Gästrikland, Dalarna S
      6 => UsdaZone.z4, // Hälsingland, Jämtland
      7 => UsdaZone.z3, // Ångermanland, Västerbotten
      8 => UsdaZone.z2, // Lappland
      _ => UsdaZone.z5,
    };
  }

  /// USDA zone → closest Swedish zone equivalent (lossy — multiple USDA
  /// zones collapse to one Swedish zone). Used when the user is in
  /// e.g. Germany and we still need to pick a calibration baseline
  /// from the plant database.
  static int usdaToSwedish(UsdaZone usda) {
    return switch (usda) {
      UsdaZone.z1 || UsdaZone.z2 => 8,
      UsdaZone.z3 => 7,
      UsdaZone.z4 => 6,
      UsdaZone.z5 => 5,
      UsdaZone.z6 => 3,
      UsdaZone.z7 => 2,
      UsdaZone.z8 => 1,
      // USDA 9+ has no Swedish equivalent — clamp to "warmer than 1"
      // and trust the season-shifter to do the work.
      _ => 1,
    };
  }
}

/// Computed climate profile for a given (lat, lon) location.
class ClimateProfile {
  final Hemisphere hemisphere;
  final UsdaZone usdaZone;
  final int swedishZoneEquivalent;
  final double latitude;
  final double longitude;

  const ClimateProfile({
    required this.hemisphere,
    required this.usdaZone,
    required this.swedishZoneEquivalent,
    required this.latitude,
    required this.longitude,
  });

  factory ClimateProfile.fromCoordinates(double lat, double lon) {
    final hemi = Hemisphere.forLatitude(lat);
    final usda = UsdaZone.forCoordinates(lat, lon);
    final sv = ZoneCrosswalk.usdaToSwedish(usda);
    return ClimateProfile(
      hemisphere: hemi,
      usdaZone: usda,
      swedishZoneEquivalent: sv,
      latitude: lat,
      longitude: lon,
    );
  }

  /// Apply hemisphere shift to a single month (1-12). Used when reading
  /// plant.json — every sowing/harvest date is calibrated for the
  /// northern hemisphere; southern hemisphere users see them flipped.
  int shiftMonth(int month) => hemisphere.shiftMonth(month);

  /// Whether this profile is meaningfully outside the Sweden-calibrated
  /// baseline. Used to decide if zone labels should say "Zon 3" (sv)
  /// or "USDA 6" (international).
  bool get isOutsideSweden {
    // Sweden spans ~55°N to ~69°N, ~11°E to ~24°E. Anything well
    // outside that box is "international".
    return latitude < 54 ||
        latitude > 70 ||
        longitude < 8 ||
        longitude > 28;
  }
}
