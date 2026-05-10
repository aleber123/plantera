import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/zone_service.dart';

class WeatherCard extends StatelessWidget {
  final WeatherService weather;
  final ZoneService zone;

  const WeatherCard({super.key, required this.weather, required this.zone});

  @override
  Widget build(BuildContext context) {
    if (weather.loading && weather.forecast.isEmpty) {
      return const Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    if (weather.forecast.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: const Icon(Icons.cloud_off),
          title: Text(l10n.weatherUnavailable),
          subtitle: Text(weather.error ?? l10n.weatherSetLocationHint),
        ),
      );
    }

    final frost = weather.nextFrostDay;
    final today = weather.forecast.first;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconFor(today.smhiSymbolCode),
                    color: Colors.orange.shade700, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(zone.city ?? zone.zoneLabel,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(today.symbolDescription,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 13)),
                    ],
                  ),
                ),
                Text('${today.maxTempC.toStringAsFixed(0)}°',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text('/${today.minTempC.toStringAsFixed(0)}°',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
            if (frost != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.ac_unit, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.weatherFrostWarning(
                          DateFormat('d MMM', localeName).format(frost.date),
                          frost.minTempC.toStringAsFixed(0),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: weather.forecast.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 10),
                itemBuilder: (ctx, i) =>
                    _dayTile(weather.forecast[i], localeName),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayTile(WeatherDay d, String localeName) {
    return Container(
      width: 58,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: d.isFrostRisk ? Colors.lightBlue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat.E(localeName).format(d.date).toLowerCase(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Icon(_iconFor(d.smhiSymbolCode), size: 18),
          const SizedBox(height: 2),
          Text('${d.maxTempC.toStringAsFixed(0)}°/${d.minTempC.toStringAsFixed(0)}°',
              style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  static IconData _iconFor(int symbol) {
    if (symbol <= 2) return Icons.wb_sunny;
    if (symbol <= 4) return Icons.wb_cloudy;
    if (symbol <= 7) return Icons.cloud;
    if (symbol == 11 || symbol == 21) return Icons.flash_on;
    if (symbol >= 25) return Icons.ac_unit;
    if (symbol >= 15 && symbol <= 17) return Icons.cloudy_snowing;
    if (symbol >= 8 && symbol <= 20) return Icons.water_drop;
    return Icons.cloud;
  }
}
