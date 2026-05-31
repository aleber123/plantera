class WeatherDay {
  final DateTime date;
  final double minTempC;
  final double maxTempC;
  final String symbolDescription;
  final int smhiSymbolCode;
  final double precipitationMm;
  final double windSpeedMs;

  const WeatherDay({
    required this.date,
    required this.minTempC,
    required this.maxTempC,
    required this.symbolDescription,
    required this.smhiSymbolCode,
    required this.precipitationMm,
    required this.windSpeedMs,
  });

  /// True if there's a meaningful frost risk for tender plants.
  ///
  /// SMHI returns 2-meter air temperature. Actual ground/leaf
  /// temperature is typically 1-3 °C COLDER on clear-sky nights due
  /// to radiative cooling — so botanic frost (ice crystals on tender
  /// foliage) starts when 2 m air drops to roughly 2-3 °C.
  ///
  /// Previous threshold of `<= 2.0` was too high — it false-flagged
  /// every cool spring night as "frost" and trained users to ignore
  /// the warnings. We now separate two bands:
  ///   - `isFrostRisk`        → true frost (ice possible at ground)
  ///   - `isFrostAdvisory`    → still cold enough that tender annuals
  ///                            (tomato, basil) suffer cold damage
  bool get isFrostRisk => minTempC <= 0.0;

  /// Cold but not freezing — surfaces a softer "cover sensitive plants"
  /// hint for tender warm-origin annuals. Doesn't trigger the loudest
  /// frost-emergency UI.
  bool get isFrostAdvisory => minTempC > 0.0 && minTempC <= 3.0;
}
