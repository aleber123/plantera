import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/daily_insight.dart';
import '../screens/plant_detail_screen.dart';
import '../services/garden_service.dart';
import '../services/insights_service.dart';
import '../services/plant_database_service.dart';
import '../services/weather_service.dart';
import '../services/zone_service.dart';

/// "Idag i trädgården" — top-of-home actionable list. Computed live from
/// garden + plants + weather; no extra storage. Combines what we already
/// know to surface the next thing the user should do.
class DailyInsightsCard extends StatelessWidget {
  const DailyInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<GardenService, PlantDatabaseService, WeatherService>(
      builder: (ctx, garden, db, weather, _) {
        if (!garden.loaded) return const SizedBox.shrink();
        if (garden.plants.isEmpty) return const SizedBox.shrink();
        final zone = ctx.watch<ZoneService>().zone;

        final insights = InsightsService.compute(
          garden: garden.plants,
          plantLookup: db.byId,
          forecast: weather.forecast,
          zone: zone,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6E5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCDE0AB)),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('☀️', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text(
                      'Idag i trädgården',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D5016),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (insights.isEmpty)
                  _AllGood()
                else
                  for (final i in insights.take(6))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _InsightTile(insight: i),
                    ),
                if (insights.length > 6)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+ ${insights.length - 6} till',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF44523A),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AllGood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Text('✅', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Allt under kontroll. Inget akut just nu — njut av trädgården.',
              style: TextStyle(fontSize: 13.5, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final DailyInsight insight;
  const _InsightTile({required this.insight});

  @override
  Widget build(BuildContext context) {
    final accent = switch (insight.urgency) {
      InsightUrgency.high => const Color(0xFFD84315),
      InsightUrgency.medium => const Color(0xFF558B2F),
      InsightUrgency.low => const Color(0xFF6D7E5F),
    };
    final tile = Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(insight.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight.body,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (insight.gardenPlantId != null)
            Icon(Icons.chevron_right, color: accent.withValues(alpha: 0.7)),
        ],
      ),
    );

    if (insight.gardenPlantId == null) return tile;
    return GestureDetector(
      onTap: () => _open(context, insight.gardenPlantId!),
      child: tile,
    );
  }

  void _open(BuildContext context, String gardenPlantId) {
    final garden = context.read<GardenService>();
    final db = context.read<PlantDatabaseService>();
    final gp = garden.plants.where((g) => g.id == gardenPlantId).firstOrNull;
    if (gp == null) return;
    final plant = db.byId(gp.plantId);
    if (plant == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlantDetailScreen(plant: plant, gardenPlant: gp),
      ),
    );
  }
}
