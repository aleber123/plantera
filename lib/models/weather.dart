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

  bool get isFrostRisk => minTempC <= 2.0;
}
