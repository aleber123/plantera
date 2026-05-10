import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../services/garden_service.dart';
import '../services/plant_database_service.dart';
import '../services/zone_service.dart';
import '../utils/garden_progress.dart';
import 'plant_detail_screen.dart';

/// Full "Närmsta skörd"-lista — visar progress-bars för **alla** växter
/// i den aktiva trädgården, sorterat efter dagar tills skörd. Hem-kortet
/// visar bara top 3; här ser användaren hela skördekalendern på en
/// skärm med samma visuella språk.
class AllHarvestsScreen extends StatelessWidget {
  const AllHarvestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Närmsta skörd')),
      body: Consumer3<GardenService, PlantDatabaseService, ZoneService>(
        builder: (ctx, garden, db, zoneService, _) {
          final zone = zoneService.zone;
          final entries = <_Entry>[];
          for (final gp in garden.plants) {
            final plant = db.byId(gp.plantId);
            if (plant == null) continue;
            entries.add(_Entry(
              gp: gp,
              plant: plant,
              progress: GardenProgress.compute(gp, plant, zone: zone),
            ));
          }
          // Same sort as the home overview card — past-harvest first
          // (oldest "overdue"), then closest to harvest, then unknowns
          // last. This ordering is what the user expects after tapping
          // "+N till" on the home card.
          entries.sort((a, b) {
            final aDays = a.progress.daysLeft;
            final bDays = b.progress.daysLeft;
            if (aDays == null && bDays == null) return 0;
            if (aDays == null) return 1;
            if (bDays == null) return -1;
            return aDays.compareTo(bDays);
          });

          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌱', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'Inga växter med skördeprognos',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: entries.length,
            itemBuilder: (_, i) => _Row(entry: entries[i]),
          );
        },
      ),
    );
  }
}

class _Entry {
  final GardenPlant gp;
  final Plant plant;
  final GardenProgress progress;
  _Entry({required this.gp, required this.plant, required this.progress});
}

class _Row extends StatelessWidget {
  final _Entry entry;
  const _Row({required this.entry});

  @override
  Widget build(BuildContext context) {
    final accent = Color(entry.plant.kategori.accentArgb);
    final progress = entry.progress;
    final daysLeft = progress.daysLeft ?? 0;
    final label = progress.isReady
        ? 'Redo att skördas'
        : daysLeft <= 0
            ? 'Skörda nu'
            : daysLeft <= 7
                ? '$daysLeft dagar kvar'
                : '~$daysLeft dagar kvar';

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlantDetailScreen(
            plant: entry.plant,
            gardenPlant: entry.gp,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Text(entry.plant.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.gp.customName ?? entry.plant.namnSv,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F2A1A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: progress.isReady
                              ? accent
                              : daysLeft <= 0
                                  ? const Color(0xFFC62828)
                                  : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (progress.hasData)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress.fraction,
                        minHeight: 6,
                        backgroundColor: accent.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    )
                  else
                    Text(
                      'Ingen tidsräknare för den här växten',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
