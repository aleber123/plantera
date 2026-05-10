import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/harvest_entry.dart';
import '../models/plant.dart';
import '../services/garden_service.dart';
import '../services/harvest_service.dart';
import '../services/plant_database_service.dart';
import '../utils/harvest_value.dart';
import '../utils/plant_families.dart';

/// "Min trädgård YYYY" — full-screen pride view that summarises the
/// gardener's year. Designed to feel like a small accomplishment screen
/// rather than a dashboard: big numbers, clear hierarchy, soft greens.
///
/// Pulls from [GardenService] (count + species), [HarvestService]
/// (total harvested, by species, by unit) and [HarvestValue] (rough
/// estimated SEK value).
class GardenStatsScreen extends StatelessWidget {
  const GardenStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final year = DateTime.now().year;
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F1),
      appBar: AppBar(
        title: Text(l10n.statsTitle(year.toString())),
        backgroundColor: const Color(0xFFFAF8F1),
        elevation: 0,
      ),
      body: Consumer3<GardenService, HarvestService, PlantDatabaseService>(
        builder: (ctx, garden, harvest, db, _) {
          final stats = _Stats.compute(
            garden: garden,
            harvest: harvest,
            db: db,
            year: year,
          );

          if (stats.isEmpty) return _emptyState(ctx);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              _Hero(stats: stats, year: year),
              const SizedBox(height: 16),
              _BigNumberRow(stats: stats),
              const SizedBox(height: 16),
              if (stats.harvestEntries > 0) _HarvestPanel(stats: stats),
              if (stats.harvestEntries > 0) const SizedBox(height: 16),
              if (stats.topSpecies.isNotEmpty) _TopSpeciesPanel(stats: stats),
              if (stats.topSpecies.isNotEmpty) const SizedBox(height: 16),
              if (stats.locations.isNotEmpty) _LocationsPanel(stats: stats),
              if (stats.locations.isNotEmpty) const SizedBox(height: 16),
              if (stats.rotationByLocation.isNotEmpty)
                _RotationPanel(stats: stats),
              if (stats.rotationByLocation.isNotEmpty)
                const SizedBox(height: 16),
              _Reflection(stats: stats, year: year),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyState(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(
              l10n.statsEmptyTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.statsEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stats {
  final int totalPlants;
  final int speciesCount;
  final int harvestEntries;
  final double estimatedSek;
  final Map<HarvestUnit, double> harvestByUnit;
  final List<({String name, String emoji, double sek})> topSpecies;
  final Map<String, int> locations;
  final int readyNow;
  final int harvested;
  /// {location → {year → set of families that grew there}}
  final Map<String, Map<int, Set<PlantFamily>>> rotationByLocation;

  const _Stats({
    required this.totalPlants,
    required this.speciesCount,
    required this.harvestEntries,
    required this.estimatedSek,
    required this.harvestByUnit,
    required this.topSpecies,
    required this.locations,
    required this.readyNow,
    required this.harvested,
    required this.rotationByLocation,
  });

  bool get isEmpty => totalPlants == 0 && harvestEntries == 0;

  static _Stats compute({
    required GardenService garden,
    required HarvestService harvest,
    required PlantDatabaseService db,
    required int year,
  }) {
    final speciesIds = <String>{};
    final locationCount = <String, int>{};
    final rotation = <String, Map<int, Set<PlantFamily>>>{};
    var readyNow = 0;
    var harvested = 0;
    for (final gp in garden.plants) {
      speciesIds.add(gp.plantId);
      final loc = (gp.location ?? '').trim();
      if (loc.isNotEmpty) {
        locationCount[loc] = (locationCount[loc] ?? 0) + 1;
        // Group rotation history by year planted, not createdAt — when
        // someone backfills last year's tomato bed they want it to
        // count for *that* year, not today.
        final byYear = rotation.putIfAbsent(loc, () => {});
        final fams = byYear.putIfAbsent(gp.plantedDate.year, () => {});
        fams.add(PlantFamily.fromPlantId(gp.plantId));
      }
      if (gp.status == PlantStatus.skordeklar) readyNow++;
      if (gp.status == PlantStatus.skordad) harvested++;
    }

    final harvestThisYear =
        harvest.entries.where((e) => e.date.year == year).toList();
    final byUnit = <HarvestUnit, double>{};
    final perPlantSek = <String, double>{}; // plantId → SEK
    final perPlantPlant = <String, Plant>{};
    var totalSek = 0.0;
    for (final e in harvestThisYear) {
      byUnit[e.unit] = (byUnit[e.unit] ?? 0) + e.amount;
      // Find plant via gardenPlantId
      GardenPlant? gp;
      for (final g in garden.plants) {
        if (g.id == e.gardenPlantId) {
          gp = g;
          break;
        }
      }
      if (gp == null) continue;
      final plant = db.byId(gp.plantId);
      if (plant == null) continue;
      final sek = HarvestValue.estimateSek(plant, e.unit, e.amount);
      totalSek += sek;
      perPlantSek[plant.id] = (perPlantSek[plant.id] ?? 0) + sek;
      perPlantPlant[plant.id] = plant;
    }

    final ranked = perPlantSek.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = <({String name, String emoji, double sek})>[];
    for (final e in ranked.take(3)) {
      final p = perPlantPlant[e.key]!;
      top.add((name: p.namnSv, emoji: p.emoji, sek: e.value));
    }

    return _Stats(
      totalPlants: garden.plants.length,
      speciesCount: speciesIds.length,
      harvestEntries: harvestThisYear.length,
      estimatedSek: totalSek,
      harvestByUnit: byUnit,
      topSpecies: top,
      locations: locationCount,
      readyNow: readyNow,
      harvested: harvested,
      rotationByLocation: rotation,
    );
  }
}

class _Hero extends StatelessWidget {
  final _Stats stats;
  final int year;
  const _Hero({required this.stats, required this.year});

  @override
  Widget build(BuildContext context) {
    final headline = _headline(context);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7CB342), Color(0xFF558B2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Säsongen $year',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.85),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            headline,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  String _headline(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (stats.harvestEntries == 0 && stats.totalPlants == 0) {
      return l10n.statsHeroEmpty;
    }
    if (stats.harvestEntries == 0) {
      return l10n.statsHero2(stats.totalPlants.toString());
    }
    if (stats.estimatedSek > 100) {
      return l10n.statsHero1(stats.estimatedSek.round().toString());
    }
    return l10n.statsHero2(stats.totalPlants.toString());
  }
}

class _BigNumberRow extends StatelessWidget {
  final _Stats stats;
  const _BigNumberRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _BigNumberTile(
          value: '${stats.totalPlants}',
          label: l10n.statsTilePlants,
          icon: '🌿',
        ),
        const SizedBox(width: 10),
        _BigNumberTile(
          value: '${stats.speciesCount}',
          label: l10n.statsTileSpecies,
          icon: '🌸',
        ),
        const SizedBox(width: 10),
        _BigNumberTile(
          value: '${stats.harvested}',
          label: l10n.statsTileHarvested,
          icon: '🧺',
        ),
      ],
    );
  }
}

class _BigNumberTile extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  const _BigNumberTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEDEDE2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HarvestPanel extends StatelessWidget {
  final _Stats stats;
  const _HarvestPanel({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Panel(
      title: l10n.statsHarvestPanelTitle,
      emoji: '🧺',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in stats.harvestByUnit.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(
                    _formatAmount(entry.value, entry.key),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2A1A),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _unitLabel(entry.key),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          if (stats.estimatedSek > 0) ...[
            const Divider(height: 18),
            Row(
              children: [
                const Text('💰', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.statsValueLine(stats.estimatedSek.round().toString()),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF558B2F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.statsValueDisclaimer,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatAmount(double v, HarvestUnit u) {
    if (u == HarvestUnit.g && v >= 1000) {
      return (v / 1000).toStringAsFixed(1).replaceAll('.', ',');
    }
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toStringAsFixed(1).replaceAll('.', ',');
  }

  String _unitLabel(HarvestUnit u) => switch (u) {
        HarvestUnit.kg => 'kg',
        HarvestUnit.g => 'g',
        HarvestUnit.st => 'st',
        HarvestUnit.liter => 'liter',
      };
}

class _TopSpeciesPanel extends StatelessWidget {
  final _Stats stats;
  const _TopSpeciesPanel({required this.stats});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: AppLocalizations.of(context).statsTopPanelTitle,
      emoji: '🏆',
      child: Column(
        children: [
          for (var i = 0; i < stats.topSpecies.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      '#${i + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Text(stats.topSpecies[i].emoji,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      stats.topSpecies[i].name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2A1A),
                      ),
                    ),
                  ),
                  Text(
                    '~${stats.topSpecies[i].sek.round()} kr',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF558B2F),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LocationsPanel extends StatelessWidget {
  final _Stats stats;
  const _LocationsPanel({required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.locations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return _Panel(
      title: AppLocalizations.of(context).statsLocationPanelTitle,
      emoji: '📍',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final e in entries)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6E5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCDE0AB)),
              ),
              child: Text(
                '${e.key} · ${e.value}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D5016),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Panel surfacing crop rotation per location: which families grew
/// where, in which year. Flags repeats — same family in the same
/// location two years in a row — because that's the rotation signal
/// most worth catching for the average gardener.
class _RotationPanel extends StatelessWidget {
  final _Stats stats;
  const _RotationPanel({required this.stats});

  @override
  Widget build(BuildContext context) {
    final rows = stats.rotationByLocation.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final l10n = AppLocalizations.of(context);
    return _Panel(
      title: l10n.statsRotationPanelTitle,
      emoji: '🔁',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsRotationBody,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          for (final r in rows) ...[
            _RotationRow(location: r.key, byYear: r.value),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RotationRow extends StatelessWidget {
  final String location;
  final Map<int, Set<PlantFamily>> byYear;
  const _RotationRow({required this.location, required this.byYear});

  @override
  Widget build(BuildContext context) {
    final years = byYear.keys.toList()..sort();
    // Find families that repeat from one year to the next at this
    // location — the gardener's biggest rotation mistake.
    final repeats = <PlantFamily>{};
    for (var i = 1; i < years.length; i++) {
      final prev = byYear[years[i - 1]]!;
      final curr = byYear[years[i]]!;
      for (final f in curr) {
        if (f != PlantFamily.other && prev.contains(f)) {
          repeats.add(f);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.place_rounded,
                size: 14, color: Color(0xFF558B2F)),
            const SizedBox(width: 5),
            Text(
              location,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        for (final y in years.reversed) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 38,
                  child: Text(
                    '$y',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final f in byYear[y]!)
                        _FamilyBadge(
                          family: f,
                          repeated: repeats.contains(f),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        if (repeats.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4D6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE6C77A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Samma familj två år i rad: ${repeats.map((f) => f.label.toLowerCase()).join(", ")}. ${repeats.first.rotationTip}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5A3B00),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _FamilyBadge extends StatelessWidget {
  final PlantFamily family;
  final bool repeated;
  const _FamilyBadge({required this.family, required this.repeated});

  @override
  Widget build(BuildContext context) {
    final accent = Color(family.accentArgb);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: repeated ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(10),
        border: repeated
            ? Border.all(color: accent.withValues(alpha: 0.5), width: 1)
            : null,
      ),
      child: Text(
        family.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}

class _Reflection extends StatelessWidget {
  final _Stats stats;
  final int year;
  const _Reflection({required this.stats, required this.year});

  @override
  Widget build(BuildContext context) {
    final month = DateTime.now().month;
    final body = _bodyText(month);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D26A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌟', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).statsReflectionTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7A4F00),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF5A3B00),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _bodyText(int month) {
    if (month <= 3) {
      return 'Säsongen är ung. Det här är det perfekta läget att planera, så frön och drömma stort om vad som ska bli.';
    }
    if (month <= 6) {
      return 'Mitt i odlingen. Försök fota allt som blommar – om ett halvår är minnet ditt enda kvitto.';
    }
    if (month <= 8) {
      return 'Skörd! Notera ner vilka sorter som funkat bäst – nästa år vill du veta exakt.';
    }
    if (month <= 10) {
      return 'Säsongen tar slut. Skriv ner vad som gick bra och vad som ska bort. Det är minnesanteckningar för nästa vår.';
    }
    return 'Vintern är mentalt arbete. Beställ frön i god tid, planera om rabatterna och fundera på växtföljd.';
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final String emoji;
  final Widget child;
  const _Panel({
    required this.title,
    required this.emoji,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEDE2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
