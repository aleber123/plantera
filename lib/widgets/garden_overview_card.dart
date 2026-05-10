import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../screens/all_harvests_screen.dart';
import '../screens/main_shell.dart';
import '../screens/plant_detail_screen.dart';
import '../services/garden_service.dart';
import '../services/plant_database_service.dart';
import '../services/zone_service.dart';
import '../utils/garden_progress.dart';

/// "Närmsta skörd" — top-of-home progress card that surfaces the 3
/// plants closest to harvest with mini progress bars. Renamed from
/// "Min trädgård just nu" to avoid colliding with the dedicated
/// "Mina växter"-tab; this card is purely about *time-to-harvest*,
/// the tab is about the full garden.
///
/// Tap a row → opens that plant's detail. Tap "Se alla" → switches
/// to the My Garden tab.
class GardenOverviewCard extends StatelessWidget {
  const GardenOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<GardenService, PlantDatabaseService, ZoneService>(
      builder: (ctx, garden, db, zoneService, _) {
        final all = garden.plants;
        if (all.isEmpty) return const _EmptyGardenCard();
        final zone = zoneService.zone;

        // Pair every garden plant with its database row + computed
        // progress, then sort by least-days-left so harvest-ready
        // plants float to the top. Progress is zone-shifted: jordgubbe
        // i Skåne reports earlier than the same plant i Norrland.
        final entries = <_Entry>[];
        for (final gp in all) {
          final plant = db.byId(gp.plantId);
          if (plant == null) continue;
          entries.add(_Entry(
            gp: gp,
            plant: plant,
            progress: GardenProgress.compute(gp, plant, zone: zone),
          ));
        }
        entries.sort((a, b) {
          // Past-harvest first (oldest "overdue"), then closest to
          // harvest, then unknowns last.
          final aDays = a.progress.daysLeft;
          final bDays = b.progress.daysLeft;
          if (aDays == null && bDays == null) return 0;
          if (aDays == null) return 1;
          if (bDays == null) return -1;
          return aDays.compareTo(bDays);
        });

        final readyCount =
            entries.where((e) => e.progress.isReady).length;
        final soonCount = entries
            .where((e) =>
                !e.progress.isReady &&
                (e.progress.daysLeft ?? 999) <= 14)
            .length;

        final top = entries.take(3).toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEDEDE2)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: title + counts + "Se alla"
                Row(
                  children: [
                    const Text('🌱', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).gardenOverviewTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2A1A),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          MainShellController.of(context)?.goToTab(3),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(AppLocalizations.of(context).gardenSeeAll),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _StatsRow(
                  total: entries.length,
                  ready: readyCount,
                  soon: soonCount,
                ),
                const SizedBox(height: 12),
                for (final e in top) _MiniRow(entry: e),
                if (entries.length > 3) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AllHarvestsScreen(),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.list_rounded, size: 16),
                      label: Text(
                        AppLocalizations.of(context)
                            .gardenMore(entries.length.toString()),
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Entry {
  final GardenPlant gp;
  final Plant plant;
  final GardenProgress progress;
  _Entry({required this.gp, required this.plant, required this.progress});
}

class _StatsRow extends StatelessWidget {
  final int total;
  final int ready;
  final int soon;
  const _StatsRow({
    required this.total,
    required this.ready,
    required this.soon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _Pill(label: l10n.gardenStatTotal, value: '$total'),
        const SizedBox(width: 6),
        _Pill(label: l10n.gardenStatHarvestSoon, value: '$soon', accent: 0xFFF6A700),
        const SizedBox(width: 6),
        _Pill(label: l10n.gardenStatReadyNow, value: '$ready', accent: 0xFF4CAF50),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final String value;
  final int? accent;
  const _Pill({required this.label, required this.value, this.accent});

  @override
  Widget build(BuildContext context) {
    final color = accent != null ? Color(accent!) : const Color(0xFF4D6647);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniRow extends StatelessWidget {
  final _Entry entry;
  const _MiniRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final accent = Color(entry.plant.kategori.accentArgb);
    final progress = entry.progress;
    final daysLeft = progress.daysLeft ?? 0;
    final l10n = AppLocalizations.of(context);
    final label = progress.isReady
        ? l10n.progressReadyToHarvest
        : daysLeft <= 0
            ? l10n.progressHarvestNow
            : daysLeft <= 7
                ? l10n.progressDaysLeft(daysLeft.toString())
                : l10n.progressApproxDaysLeft(daysLeft.toString());
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PlantDetailScreen(
            plant: entry.plant,
            gardenPlant: entry.gp,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            Text(entry.plant.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2A1A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: progress.isReady ? accent : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (progress.hasData)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.fraction,
                        minHeight: 5,
                        backgroundColor: accent.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    )
                  else
                    Text(
                      'Planterad ${entry.gp.plantedDate.day}/${entry.gp.plantedDate.month}',
                      style: TextStyle(
                        fontSize: 11,
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

/// Friendly first-launch state — replaces the old terse "Tom trädgård"
/// with a hero-CTA so a brand-new user immediately knows where to go.
/// Bigger emoji, warmer copy, primary action takes the whole row.
class _EmptyGardenCard extends StatelessWidget {
  const _EmptyGardenCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEFF6E5), Color(0xFFCDE0AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCDE0AB)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text('🌱', style: TextStyle(fontSize: 56)),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.homeWelcomeTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.homeWelcomeBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF558B2F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => MainShellController.of(context)?.openPlantDatabase(context),
              icon: const Icon(Icons.search),
              label: Text(
                l10n.homeWelcomeCta,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
