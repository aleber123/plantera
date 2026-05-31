import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../services/garden_service.dart';
import '../services/plant_database_service.dart';
import '../widgets/plant_hero_avatar.dart';
import '../services/premium_service.dart';
import 'garden_stats_screen.dart';
import 'paywall_screen.dart';
import 'plant_database_screen.dart';
import 'plant_detail_screen.dart';

/// "Min trädgård" — full list of every garden plant the user owns. With
/// 30+ plants the original flat list became unmanageable, so the screen
/// now offers:
///
/// - **Search** by name (custom name, plant name, or latin)
/// - **Filter chips** for status (planerad / förodlad / ute / skördad)
/// - **Group by location** when the user has location data on plants —
///   otherwise grouped by status
class MyGardenScreen extends StatefulWidget {
  const MyGardenScreen({super.key});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

enum _GroupMode { byStatus, byLocation, byCategory }

class _MyGardenScreenState extends State<MyGardenScreen> {
  String _search = '';
  PlantStatus? _statusFilter;
  _GroupMode _group = _GroupMode.byStatus;
  final _searchCtl = TextEditingController();

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myGardenTitle),
        actions: [
          IconButton(
            tooltip: l10n.myGardenSeasonStatsTooltip(
                DateTime.now().year.toString()),
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const GardenStatsScreen(),
              ),
            ),
          ),
          PopupMenuButton<_GroupMode>(
            tooltip: l10n.myGardenGroupTooltip,
            icon: const Icon(Icons.sort),
            onSelected: (g) => setState(() => _group = g),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _GroupMode.byStatus,
                child: Text(l10n.myGardenGroupByStatus),
              ),
              PopupMenuItem(
                value: _GroupMode.byLocation,
                child: Text(l10n.myGardenGroupByLocation),
              ),
              PopupMenuItem(
                value: _GroupMode.byCategory,
                child: Text(l10n.myGardenGroupByCategory),
              ),
            ],
          ),
        ],
      ),
      body: Consumer2<GardenService, PlantDatabaseService>(
        builder: (ctx, garden, db, _) {
          if (garden.plants.isEmpty) return _empty(ctx);

          final filtered = _applyFilters(garden.plants, db);
          final grouped = _groupItems(filtered, db, l10n);

          return Column(
            children: [
              _SearchAndFilters(
                searchCtl: _searchCtl,
                onSearchChanged: (v) => setState(() => _search = v),
                statusFilter: _statusFilter,
                onStatusChanged: (s) => setState(() => _statusFilter = s),
                totalShown: filtered.length,
                totalAll: garden.plants.length,
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _noResults(l10n)
                    : ListView.builder(
                        itemCount: grouped.length,
                        itemBuilder: (_, i) {
                          final entry = grouped[i];
                          return _GroupSection(
                            title: entry.title,
                            plants: entry.items,
                            db: db,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.myGardenAddPlant),
      ),
    );
  }

  List<GardenPlant> _applyFilters(
      List<GardenPlant> all, PlantDatabaseService db) {
    final q = _search.trim().toLowerCase();
    return all.where((gp) {
      if (_statusFilter != null && gp.status != _statusFilter) return false;
      if (q.isEmpty) return true;
      final plant = db.byId(gp.plantId);
      final name = (gp.customName ?? plant?.namnSv ?? '').toLowerCase();
      final lat = (plant?.namnLat ?? '').toLowerCase();
      final loc = (gp.location ?? '').toLowerCase();
      return name.contains(q) || lat.contains(q) || loc.contains(q);
    }).toList();
  }

  List<({String title, List<GardenPlant> items})> _groupItems(
      List<GardenPlant> plants,
      PlantDatabaseService db,
      AppLocalizations l10n) {
    String keyFor(GardenPlant gp) {
      switch (_group) {
        case _GroupMode.byStatus:
          return gp.status.label;
        case _GroupMode.byLocation:
          final loc = (gp.location ?? '').trim();
          return loc.isEmpty ? l10n.myGardenLocationNone : loc;
        case _GroupMode.byCategory:
          final p = db.byId(gp.plantId);
          return p?.kategori.label ?? l10n.myGardenCategoryOther;
      }
    }

    final byKey = <String, List<GardenPlant>>{};
    for (final gp in plants) {
      byKey.putIfAbsent(keyFor(gp), () => []).add(gp);
    }
    final keys = byKey.keys.toList()..sort();
    return keys
        .map((k) => (title: k, items: byKey[k]!))
        .toList();
  }

  Widget _noResults(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            l10n.myGardenNoResults,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.myGardenNoResultsBody,
            style: TextStyle(color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🪴', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text(l10n.myGardenEmptyTitle,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            l10n.myGardenEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _add(ctx),
            icon: const Icon(Icons.search),
            label: Text(l10n.myGardenEmptyCta),
          ),
        ],
      ),
    );
  }

  void _add(BuildContext ctx) {
    final premium = ctx.read<PremiumService>();
    final garden = ctx.read<GardenService>();
    if (!premium.canAddGardenPlant(garden.plantCount)) {
      Navigator.of(ctx).push(
        MaterialPageRoute(
            builder: (_) => const PaywallScreen(source: 'garden_limit')),
      );
      return;
    }
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (_) => const PlantDatabaseScreen()),
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  final TextEditingController searchCtl;
  final ValueChanged<String> onSearchChanged;
  final PlantStatus? statusFilter;
  final ValueChanged<PlantStatus?> onStatusChanged;
  final int totalShown;
  final int totalAll;

  const _SearchAndFilters({
    required this.searchCtl,
    required this.onSearchChanged,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.totalShown,
    required this.totalAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchCtl,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: l10n.myGardenSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchCtl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchCtl.clear();
                        onSearchChanged('');
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _Chip(
                  label: l10n.myGardenFilterAll,
                  selected: statusFilter == null,
                  onTap: () => onStatusChanged(null),
                ),
                for (final s in PlantStatus.values)
                  _Chip(
                    label: s.label,
                    selected: statusFilter == s,
                    onTap: () => onStatusChanged(
                      statusFilter == s ? null : s,
                    ),
                  ),
              ],
            ),
          ),
          if (totalShown != totalAll) ...[
            const SizedBox(height: 4),
            Text(
              l10n.myGardenShowingCount(
                  totalShown.toString(), totalAll.toString()),
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF2D5016),
        ),
        selectedColor: const Color(0xFF558B2F),
        backgroundColor: const Color(0xFFEFF6E5),
        side: BorderSide(
          color:
              selected ? const Color(0xFF558B2F) : const Color(0xFFCDE0AB),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  final String title;
  final List<GardenPlant> plants;
  final PlantDatabaseService db;

  const _GroupSection({
    required this.title,
    required this.plants,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D5016),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${plants.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        for (final gp in plants)
          _GardenRow(gp: gp, plant: db.byId(gp.plantId)),
      ],
    );
  }
}

// Lifecycle-aware status line. Perennials and trees show the year only
// (the user often planted them years ago and the exact date isn't
// meaningful), annuals show the precise date.
String _statusLine(BuildContext context, GardenPlant gp, Plant plant) {
  if (gp.status == PlantStatus.planerad) return gp.status.label;
  final l10n = AppLocalizations.of(context);
  final localeName = Localizations.localeOf(context).toLanguageTag();
  final isLongLived = plant.livscykel == PlantLifecycle.perennial ||
      plant.livscykel.isLongLived;
  if (isLongLived) {
    return l10n.myGardenStatusSince(
        gp.status.label, gp.plantedDate.year.toString());
  }
  return l10n.myGardenStatusOnDate(
    gp.status.label,
    DateFormat('d MMM', localeName).format(gp.plantedDate),
  );
}

// "Recently watered" = within 48h. The pill stays visible long enough
// that the user can tap-back-and-check after wandering away from the
// hose, but disappears before it becomes stale info next morning.
bool _recentlyWatered(DateTime? lastWatered) {
  if (lastWatered == null) return false;
  return DateTime.now().difference(lastWatered) < const Duration(hours: 48);
}

String _wateredAgo(BuildContext context, DateTime when) {
  final l10n = AppLocalizations.of(context);
  final d = DateTime.now().difference(when);
  if (d.inHours < 1) return l10n.myGardenWateredNow;
  if (d.inHours < 24) return l10n.myGardenWateredToday;
  return l10n.myGardenWateredYesterday;
}

class _GardenRow extends StatelessWidget {
  final GardenPlant gp;
  final Plant? plant;
  const _GardenRow({required this.gp, required this.plant});

  @override
  Widget build(BuildContext context) {
    if (plant == null) return const SizedBox.shrink();
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PlantDetailScreen(
                plant: plant!,
                gardenPlant: gp,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            children: [
              PlantHeroAvatar(
                heroPhotoPath: gp.heroPhotoPath,
                fallbackEmoji: plant!.emoji,
                size: 56,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            gp.customName ?? plant!.namnSv,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (gp.quantity > 1) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6E5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '×${gp.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D5016),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _statusLine(context, gp, plant!),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if ((gp.location ?? '').isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.place_outlined,
                                  size: 13, color: Colors.grey.shade500),
                              const SizedBox(width: 3),
                              Text(
                                gp.location!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        if (_recentlyWatered(gp.lastWatered))
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.water_drop,
                                  size: 13, color: Color(0xFF1976D2)),
                              const SizedBox(width: 3),
                              Text(
                                _wateredAgo(context, gp.lastWatered!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1976D2),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
