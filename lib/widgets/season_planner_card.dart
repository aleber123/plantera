import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/plant.dart';
import '../models/wishlist_plant.dart';
import '../screens/main_shell.dart';
import '../screens/plant_detail_screen.dart';
import '../services/plant_database_service.dart';
import '../services/season_planner_service.dart';
import '../services/zone_service.dart';
import '../utils/constants.dart';
import '../utils/zone_shift.dart';

/// "Min säsong YYYY" — wishlist of plants the user wants to grow this
/// season. Shows the next two upcoming planting windows so the user
/// always sees what's coming up next, even in February.
///
/// Tap a row → opens that plant's detail screen so they can convert
/// the wish to a real GardenPlant. Tap "+ Lägg till" → goes to plant
/// database. Empty wishlist → soft prompt with a single CTA.
class SeasonPlannerCard extends StatelessWidget {
  const SeasonPlannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SeasonPlannerService, PlantDatabaseService, ZoneService>(
      builder: (ctx, season, db, zoneSvc, _) {
        if (!season.loaded) return const SizedBox.shrink();
        final items = season.currentSeason;
        final year = DateTime.now().year;

        if (items.isEmpty) return _EmptySeasonCard(year: year);

        // Pair each wishlist item with its plant + next sowing window.
        // Sort by which plant should be planted first this year so the
        // top of the card always shows what's most imminent. Carry the
        // active garden's zone so the "X dagar kvar"/"så nu" labels are
        // zone-shifted like the rest of the app (zon 7 ripens ~4v efter
        // zon 3), instead of raw zone-3 database dates.
        final zone = zoneSvc.zone;
        final entries = <_Entry>[];
        for (final w in items) {
          final p = db.byId(w.plantId);
          if (p == null) continue;
          entries.add(_Entry(w: w, plant: p, zone: zone));
        }
        entries.sort((a, b) {
          final aDays = a.daysUntilNext ?? 9999;
          final bDays = b.daysUntilNext ?? 9999;
          return aDays.compareTo(bDays);
        });

        final top = entries.take(3).toList();
        final remaining = entries.length - top.length;

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
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
                Row(
                  children: [
                    const Text('🗓️', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)
                          .seasonPlannerTitle(year.toString()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2A1A),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppLocalizations.of(context)
                          .seasonPlannerCount(entries.length.toString()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    AppLocalizations.of(context).seasonPlannerSubtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                for (final e in top) _SeasonRow(entry: e),
                if (remaining > 0) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      AppLocalizations.of(context)
                          .gardenMore(remaining.toString()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        MainShellController.of(context)?.openPlantDatabase(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                        AppLocalizations.of(context).seasonPlannerAddCta),
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

class _Entry {
  final WishlistPlant w;
  final Plant plant;

  /// Active garden's växtzon — used to slide the database's zone-3
  /// calibrated windows to the user's actual climate.
  final int zone;
  _Entry({required this.w, required this.plant, required this.zone});

  /// Days until the next sowing window opens this year. Null when no
  /// window applies (lifecycle without forsadatum/direktsadatum) — the
  /// card shows a generic "i säsong" label for those.
  int? get daysUntilNext {
    final next = nextWindow;
    if (next == null) return null;
    return next.start.difference(DateTime.now()).inDays;
  }

  ({DateTime start, String label})? get nextWindow {
    final now = DateTime.now();
    final candidates = <(MonthRange, String)>[];
    if (plant.forsadatum != null) {
      candidates.add((plant.forsadatum!, 'förså inomhus'));
    }
    if (plant.direktsadatum != null) {
      candidates.add((plant.direktsadatum!, 'direktså'));
    }
    if (plant.utplanteringsdatum != null) {
      candidates.add((plant.utplanteringsdatum!, 'plantera ut'));
    }
    if (candidates.isEmpty) return null;
    ({DateTime start, String label})? best;
    for (final (range, label) in candidates) {
      // Zone-shift the window start so the label matches what the
      // notifications actually schedule (same ZoneShift the rest of the
      // stack uses). Roll forward a year once the shifted window has
      // closed and we're no longer inside it.
      var d = ZoneShift.shiftSeasonStart(now.year, range.startMonth, zone);
      if (d.isBefore(now) && !range.includes(now.month)) {
        d = ZoneShift.shiftSeasonStart(now.year + 1, range.startMonth, zone);
      }
      if (best == null || d.isBefore(best.start)) {
        best = (start: d, label: label);
      }
    }
    return best;
  }
}

class _SeasonRow extends StatelessWidget {
  final _Entry entry;
  const _SeasonRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final next = entry.nextWindow;
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context);
    String label;
    Color labelColor;
    if (next == null) {
      label = l10n.seasonRowInSeason;
      labelColor = Colors.grey.shade600;
    } else {
      final days = next.start.difference(now).inDays;
      if (days <= 0) {
        label = l10n.seasonRowSowNow;
        labelColor = const Color(0xFF558B2F);
      } else if (days <= 7) {
        label = l10n.seasonRowDaysAway(days.toString());
        labelColor = const Color(0xFFEF6C00);
      } else {
        final monthName =
            AppConstants.monthShortSv[next.start.month];
        label = '$monthName · ${next.label}';
        labelColor = Colors.grey.shade700;
      }
    }

    return InkWell(
      onTap: () {
        // Open this plant's detail directly — entry.plant is already in
        // hand, so we skip the round-trip through the whole database and
        // land the user right on the wish→garden-plant conversion CTA.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlantDetailScreen(plant: entry.plant),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            Text(entry.plant.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.plant.namnSv,
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
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySeasonCard extends StatelessWidget {
  final int year;
  const _EmptySeasonCard({required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEDEDE2)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          children: [
            const Text('🗓️', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .seasonPlannerEmptyTitle(year.toString()),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2A1A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    AppLocalizations.of(context).seasonPlannerEmptyBody,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () => MainShellController.of(context)?.openPlantDatabase(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(AppLocalizations.of(context).seasonPlannerEmptyCta),
            ),
          ],
        ),
      ),
    );
  }
}
