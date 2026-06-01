import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/plant.dart';
import '../services/garden_service.dart';
import '../services/plant_database_service.dart';
import '../services/weather_service.dart';

/// Always-visible drought banner on the home screen. Appears when the
/// combined past-14-day + next-7-day precipitation is below a tier
/// determined by what's actually growing outdoors:
///
///   - Any thirsty plant (`WaterNeed.riklig`) outdoors → 12mm threshold
///   - Otherwise → 6mm threshold
///
/// The user gets to see drought *before* the morning push fires, and
/// understands which of their plants is in trouble. We deliberately
/// surface this even when notifications are disabled — visual is more
/// reliable than a push the system might silence.
class DryPeriodBanner extends StatelessWidget {
  const DryPeriodBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<WeatherService, GardenService, PlantDatabaseService>(
      builder: (ctx, weather, garden, db, _) {
        final past = weather.rainLast14d;
        // Need at least the historical signal to render anything — the
        // forecast-only banner felt unreliable during cloudy-but-dry
        // weeks. If past is null we just hide and wait.
        if (past == null) return const SizedBox.shrink();
        // A failed forecast leaves _forecast empty, which makes
        // rainNext7d read as 0mm — that would fake a drought (combined
        // drops below threshold). Don't warn unless we actually have a
        // forecast and the last fetch didn't error out.
        if (weather.forecast.isEmpty || weather.error != null) {
          return const SizedBox.shrink();
        }
        final next = weather.rainNext7d;
        final combined = past + next;

        // Find outdoor plants and their thirstiest tier.
        final thirstyNames = <String>[];
        var anyOutdoor = false;
        final seenIds = <String>{};
        for (final gp in garden.plants) {
          if (!gp.status.isOutdoorActive) continue;
          final p = db.byId(gp.plantId);
          if (p == null) continue;
          if (!seenIds.add(p.id)) continue;
          anyOutdoor = true;
          if (p.vattning == WaterNeed.riklig) {
            thirstyNames.add(p.namnSv.toLowerCase());
          }
        }
        if (!anyOutdoor) return const SizedBox.shrink();

        final threshold = thirstyNames.isNotEmpty ? 12.0 : 6.0;
        if (combined >= threshold) return const SizedBox.shrink();

        final l10n = AppLocalizations.of(context);
        final pastStr = past.toStringAsFixed(past < 1 ? 1 : 0);
        final nextStr = next.toStringAsFixed(next < 1 ? 1 : 0);
        final names = thirstyNames.take(3).join(', ');
        final more = thirstyNames.length > 3 ? l10n.dryPeriodMoreSuffix : '';

        final body = thirstyNames.isNotEmpty
            ? l10n.dryPeriodBodyWithThirsty(pastStr, nextStr, names, more)
            : l10n.dryPeriodBodyGeneral(pastStr, nextStr);

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6C77A)),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💧', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dryPeriodTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7A4F00),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Color(0xFF5A3B00),
                        ),
                      ),
                    ],
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
