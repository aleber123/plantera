/// Zone-based season shift. The plant database in this app is
/// calibrated for **zone 3** (Södermanland/Mälardalen-belt) — i.e. a
/// jordgubbe with `skordeperiod.startMonth = 6` is expected to ripen
/// around June 1 *for someone in zone 3*. For colder or warmer zones
/// the same plant ripens later or earlier.
///
/// We use a flat ~1 week per zone-step model. It's not botanically
/// exact (some plants are more zone-sensitive than others) but it's
/// dramatically better than the zero-shift status quo:
///
///   Zone 1 (Skåne):     -14 days  (jordgubbe ≈ 18 maj)
///   Zone 2 (kustlandet): -7 days
///   Zone 3 (default):     0 days  (jordgubbe ≈ 1 juni)
///   Zone 4 (Mälardalen): +7 days
///   Zone 5:             +14 days
///   Zone 6:             +21 days
///   Zone 7 (Norrland):  +28 days  (jordgubbe ≈ 29 juni)
///   Zone 8:             +35 days
///
/// Applied uniformly to forsadatum, direktsadatum, utplanteringsdatum
/// and skordeperiod so the whole season ladder slides together.
class ZoneShift {
  /// Database's calibration zone. Don't change without adjusting all
  /// the plants.json date fields too.
  static const int baseZone = 3;

  /// Days to delay (positive = colder zone, later) or advance
  /// (negative = warmer zone, earlier) seasonal events.
  static int daysFor(int userZone) {
    final clamped = userZone.clamp(1, 8);
    return (clamped - baseZone) * 7;
  }

  /// Apply [daysFor] to a "month-1" reference date. Shifts the date
  /// forward/backward by the zone delta. When the database says
  /// `start_manad = 6`, the actual season start in the user's zone is
  /// `DateTime(year, 6, 1) + daysFor(zone)`.
  static DateTime shiftSeasonStart(int year, int month, int userZone) {
    return DateTime(year, month, 1)
        .add(Duration(days: daysFor(userZone)));
  }
}
