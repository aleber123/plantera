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
import '../widgets/garden_stats_share_card.dart';
import 'plant_detail_screen.dart';

/// "Min trädgård YYYY" — full-screen pride view that summarises the
/// gardener's year. Designed to feel like a small accomplishment screen
/// rather than a dashboard: big numbers, clear hierarchy, soft greens.
///
/// Pulls from [GardenService] (count + species), [HarvestService]
/// (total harvested, by species, by unit) and [HarvestValue] (rough
/// estimated SEK value).
class GardenStatsScreen extends StatefulWidget {
  const GardenStatsScreen({super.key});

  @override
  State<GardenStatsScreen> createState() => _GardenStatsScreenState();
}

class _GardenStatsScreenState extends State<GardenStatsScreen> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle(_selectedYear.toString())),
      ),
      body: Consumer3<GardenService, HarvestService, PlantDatabaseService>(
        builder: (ctx, garden, harvest, db, _) {
          final stats = _Stats.compute(
            garden: garden,
            harvest: harvest,
            db: db,
            year: _selectedYear,
          );
          final years = _availableYears(garden, harvest);
          final prevStats = _Stats.compute(
            garden: garden,
            harvest: harvest,
            db: db,
            year: _selectedYear - 1,
          );

          if (stats.isEmpty && _selectedYear == DateTime.now().year) {
            return _emptyState(ctx);
          }

          Future<void> share(Rect? origin) =>
              GardenStatsShareCard.shareYearSummary(
                context,
                year: _selectedYear,
                totalPlants: stats.totalPlants,
                speciesCount: stats.speciesCount,
                harvested: stats.harvested,
                estimatedSek: stats.estimatedSek.round(),
                topSpecies: stats.topSpecies
                    .map((t) =>
                        (name: t.name, emoji: t.emoji, sek: t.sek))
                    .toList(),
                shareText: l10n.statsShareText(_selectedYear.toString()),
                sharePositionOrigin: origin,
              );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              if (years.length > 1)
                _YearPicker(
                  years: years,
                  selected: _selectedYear,
                  onSelect: (y) => setState(() => _selectedYear = y),
                ),
              if (years.length > 1) const SizedBox(height: 12),
              _Hero(stats: stats, year: _selectedYear),
              const SizedBox(height: 8),
              if (prevStats.estimatedSek > 0 || stats.estimatedSek > 0)
                _YearComparison(
                  thisYear: stats.estimatedSek,
                  lastYear: prevStats.estimatedSek,
                  year: _selectedYear,
                ),
              const SizedBox(height: 12),
              _ShareRow(onShare: share),
              const SizedBox(height: 16),
              _BigNumberRow(stats: stats),
              const SizedBox(height: 16),
              if (stats.monthlySek.values.any((v) => v > 0)) ...[
                _MonthlyHarvestChart(
                  monthlySek: stats.monthlySek,
                  year: _selectedYear,
                ),
                const SizedBox(height: 16),
              ],
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
              _Reflection(stats: stats, year: _selectedYear),
            ],
          );
        },
      ),
    );
  }

  /// Distinct years that contain either a harvest entry or a planted
  /// GardenPlant. Always includes the current year so a fresh user
  /// still sees a year-chip even with no data yet.
  List<int> _availableYears(GardenService garden, HarvestService harvest) {
    final years = <int>{DateTime.now().year};
    for (final e in harvest.entries) {
      years.add(e.date.year);
    }
    for (final gp in garden.plants) {
      years.add(gp.plantedDate.year);
    }
    final sorted = years.toList()..sort((a, b) => b.compareTo(a));
    return sorted;
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
  final List<({String name, String emoji, double sek, String plantId})>
      topSpecies;
  final Map<String, int> locations;
  final int readyNow;
  final int harvested;
  /// {location → {year → set of families that grew there}}
  final Map<String, Map<int, Set<PlantFamily>>> rotationByLocation;
  /// Estimated SEK value of harvest per calendar month (1-12). Empty
  /// when no harvest data — chart hides itself.
  final Map<int, double> monthlySek;

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
    required this.monthlySek,
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
    var totalPlants = 0;
    for (final gp in garden.plants) {
      // Scope the inventory aggregates to the selected year — otherwise
      // "Min trädgård 2024" shows today's whole garden. A plant counts
      // for the year it was planted.
      if (gp.plantedDate.year != year) {
        // Rotation is a multi-year history view: still record beds from
        // earlier years (up to the selected one) so the rotation panel
        // can flag repeats against this year. Skip future years.
        if (gp.plantedDate.year < year) {
          final loc = (gp.location ?? '').trim();
          if (loc.isNotEmpty) {
            final byYear = rotation.putIfAbsent(loc, () => {});
            final fams = byYear.putIfAbsent(gp.plantedDate.year, () => {});
            fams.add(PlantFamily.fromPlantId(gp.plantId));
          }
        }
        continue;
      }
      totalPlants++;
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

    // Scope harvests to the active garden — otherwise a user with two
    // gardens sees the summerhouse's tomater inflating the balcony
    // stats. HarvestEntry has no gardenId column (legacy schema) so
    // we filter via the GardenPlant lookup: an entry whose
    // gardenPlantId isn't in this garden's plants is from elsewhere.
    final activeGardenPlantIds = garden.plants.map((g) => g.id).toSet();
    final harvestThisYear = harvest.entries
        .where((e) =>
            e.date.year == year &&
            activeGardenPlantIds.contains(e.gardenPlantId))
        .toList();
    final byUnit = <HarvestUnit, double>{};
    final perPlantSek = <String, double>{}; // plantId → SEK
    final perPlantPlant = <String, Plant>{};
    final monthlySek = <int, double>{for (var m = 1; m <= 12; m++) m: 0};
    var totalSek = 0.0;
    for (final e in harvestThisYear) {
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
      // Count the unit total only for priceable entries — otherwise the
      // kg/g totals include entries the SEK estimate silently dropped.
      byUnit[e.unit] = (byUnit[e.unit] ?? 0) + e.amount;
      final sek = HarvestValue.estimateSek(plant, e.unit, e.amount);
      totalSek += sek;
      perPlantSek[plant.id] = (perPlantSek[plant.id] ?? 0) + sek;
      perPlantPlant[plant.id] = plant;
      monthlySek[e.date.month] = (monthlySek[e.date.month] ?? 0) + sek;
    }

    final ranked = perPlantSek.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top =
        <({String name, String emoji, double sek, String plantId})>[];
    for (final e in ranked.take(3)) {
      final p = perPlantPlant[e.key]!;
      top.add(
          (name: p.namnSv, emoji: p.emoji, sek: e.value, plantId: p.id));
    }

    return _Stats(
      totalPlants: totalPlants,
      speciesCount: speciesIds.length,
      harvestEntries: harvestThisYear.length,
      estimatedSek: totalSek,
      harvestByUnit: byUnit,
      topSpecies: top,
      locations: locationCount,
      readyNow: readyNow,
      harvested: harvested,
      rotationByLocation: rotation,
      monthlySek: monthlySek,
    );
  }
}

/// Horizontal chip-row letting the user step between years that have
/// data. Newest first so this season is always one tap away.
class _YearPicker extends StatelessWidget {
  final List<int> years;
  final int selected;
  final ValueChanged<int> onSelect;
  const _YearPicker({
    required this.years,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final y = years[i];
          final isSelected = y == selected;
          return ChoiceChip(
            label: Text('$y',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF2D5016),
                )),
            selected: isSelected,
            onSelected: (_) => onSelect(y),
            selectedColor: const Color(0xFF558B2F),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF558B2F)
                  : const Color(0xFFCDE0AB),
            ),
          );
        },
      ),
    );
  }
}

/// Year-over-year comparison strip. Shows "+250 kr vs 2025" with a
/// green arrow up / red arrow down. Hides when neither year has any
/// SEK to compare.
class _YearComparison extends StatelessWidget {
  final double thisYear;
  final double lastYear;
  final int year;
  const _YearComparison({
    required this.thisYear,
    required this.lastYear,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final delta = thisYear - lastYear;
    final neutral = lastYear == 0 || delta.abs() < 1;
    final isUp = delta > 0;
    final color = neutral
        ? const Color(0xFF6D7378)
        : (isUp ? const Color(0xFF2D5016) : const Color(0xFFC62828));
    final icon = neutral
        ? Icons.remove
        : (isUp ? Icons.trending_up : Icons.trending_down);
    final lastYearLabel = year - 1;
    final body = neutral
        ? lastYear == 0
            ? 'Inget att jämföra med ${year - 1} ännu'
            : 'På samma nivå som $lastYearLabel'
        : '${isUp ? '+' : ''}${delta.round()} kr vs $lastYearLabel';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            body,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 12-month bar chart of estimated SEK harvest value. CustomPainter
/// keeps it dependency-free and crisp at any size. Bars without data
/// show as tiny stubs so the time scale stays readable.
class _MonthlyHarvestChart extends StatelessWidget {
  final Map<int, double> monthlySek;
  final int year;
  const _MonthlyHarvestChart({required this.monthlySek, required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
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
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Skörd per månad $year',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: CustomPaint(
              size: Size.infinite,
              painter: _BarChartPainter(monthlySek: monthlySek),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final Map<int, double> monthlySek;
  _BarChartPainter({required this.monthlySek});

  static const _months = ['j', 'f', 'm', 'a', 'm', 'j', 'j', 'a', 's', 'o', 'n', 'd'];

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = monthlySek.values.fold<double>(0, (a, b) => b > a ? b : a);
    if (maxVal <= 0) return;

    // Layout: ~12% bottom reserved for month labels, rest for bars.
    final labelHeight = 18.0;
    final chartHeight = size.height - labelHeight;
    final gap = 6.0;
    final barW = (size.width - gap * 11) / 12;

    final barPaint = Paint()..color = const Color(0xFF558B2F);
    final dimPaint = Paint()..color = const Color(0xFFEFF6E5);
    final labelStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
    );

    for (var m = 1; m <= 12; m++) {
      final value = monthlySek[m] ?? 0;
      final h = value > 0
          ? (value / maxVal) * (chartHeight - 4)
          : 3.0; // stub for empty months
      final x = (m - 1) * (barW + gap);
      final y = chartHeight - h;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barW, h),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, value > 0 ? barPaint : dimPaint);

      // Month letter label
      final tp = TextPainter(
        text: TextSpan(text: _months[m - 1], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x + (barW - tp.width) / 2, chartHeight + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.monthlySek != monthlySek;
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
    final db = context.read<PlantDatabaseService>();
    final garden = context.read<GardenService>();
    return _Panel(
      title: AppLocalizations.of(context).statsTopPanelTitle,
      emoji: '🏆',
      child: Column(
        children: [
          for (var i = 0; i < stats.topSpecies.length; i++)
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // Tap a top-species row → open that plant's detail
                // screen. Use the first GardenPlant of that species so
                // PlantDetailScreen lands on the "Min planta"-tab.
                final plantId = stats.topSpecies[i].plantId;
                final plant = db.byId(plantId);
                if (plant == null) return;
                final gp = garden.plants
                    .where((g) => g.plantId == plantId)
                    .firstOrNull;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlantDetailScreen(
                      plant: plant,
                      gardenPlant: gp,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        size: 18, color: Colors.grey.shade400),
                  ],
                ),
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
      // Only compare calendar-adjacent years — a fallow gap (e.g. 2022
      // then 2024) is good rotation, not a repeat, so don't flag it.
      if (years[i] != years[i - 1] + 1) continue;
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

/// Single-row share-CTA. Lives between the hero and the big-number grid
/// so it's the first thing a user sees after the "Du har odlat fram
/// X kr i mat"-line — peak shareability moment.
class _ShareRow extends StatelessWidget {
  final Future<void> Function(Rect? origin) onShare;
  const _ShareRow({required this.onShare});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: Builder(
        builder: (btnContext) => FilledButton.tonalIcon(
          onPressed: () {
            final box = btnContext.findRenderObject() as RenderBox?;
            final origin = box != null
                ? box.localToGlobal(Offset.zero) & box.size
                : null;
            onShare(origin);
          },
          icon: const Icon(Icons.ios_share),
          label: Text(
            l10n.statsShareButton,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: const Color(0xFFEFF6E5),
            foregroundColor: const Color(0xFF2D5016),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFCDE0AB)),
            ),
          ),
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
