import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/plant.dart';
import '../models/wishlist_plant.dart';
import '../services/notification_service.dart';
import '../services/season_planner_service.dart';
import '../services/zone_service.dart';
import 'zone_shift.dart';

/// Shared flow for "lägg till i säsongen" — used from PlantCard's
/// season-button and PlantDetailScreen's CTA so the experience is
/// identical regardless of entry point.
///
/// Adds the plant to [SeasonPlannerService] for the current calendar
/// year and schedules planting reminders (förså inomhus / direktså /
/// plantera ut) on the first day of each window via
/// [NotificationService]. Surfaces a SnackBar with what got scheduled.
///
/// Idempotent: if the plant is already on this year's wishlist, the
/// function removes it and cancels its reminders ("toggle" behaviour).
/// Returns the wishlist row when added, null when removed.
Future<WishlistPlant?> toggleSeasonWishlist(
    BuildContext context, Plant plant) async {
  final season = context.read<SeasonPlannerService>();
  final notifications = context.read<NotificationService>();
  final zone = context.read<ZoneService>();
  final messenger = ScaffoldMessenger.of(context);
  // Roll over to next year when every sowing/harvest window for this
  // plant has already passed in the current (zone-shifted) season — e.g.
  // adding a spring annual in December plans for *next* spring. Without
  // this the wish gets dates in the past (reminders skipped) and falls
  // out of "Min säsong" the moment the calendar year turns.
  final year = _seasonYearFor(plant, zone.zone);

  // Toggle off if already on the wishlist.
  WishlistPlant? existing;
  for (final w in season.items) {
    if (w.plantId == plant.id && w.seasonYear == year) {
      existing = w;
      break;
    }
  }
  if (existing != null) {
    await notifications.cancelForWishlist(existing.id);
    await season.remove(existing.id);
    messenger.showSnackBar(SnackBar(
      content: Text('${plant.namnSv} borttagen från såningslistan'),
    ));
    return null;
  }

  final w = await season.add(plantId: plant.id);
  final scheduled = await notifications.scheduleSeasonReminders(
    wishlistId: w.id,
    plant: plant,
    zone: zone.zone,
    seasonYear: year,
  );
  final body = scheduled.isEmpty
      ? '${plant.namnSv} på din såningslista – vi pingar när det blir dags att så'
      : '${plant.namnSv} på listan. Notis kommer för: ${scheduled.join(", ").toLowerCase()}';
  messenger.showSnackBar(SnackBar(
    content: Text(body),
    duration: const Duration(seconds: 4),
  ));
  return w;
}

/// Season year to file a wish under. Returns the current year while any
/// of the plant's sowing/harvest windows is still ahead (zone-shifted,
/// same calibration the notifications use), otherwise next year so a
/// late-autumn/winter add lands on the upcoming spring instead of dates
/// that have already gone by.
int _seasonYearFor(Plant plant, int zone) {
  final now = DateTime.now();
  final ranges = [
    plant.forsadatum,
    plant.direktsadatum,
    plant.utplanteringsdatum,
    plant.skordeperiod,
  ];
  for (final range in ranges) {
    if (range == null) continue;
    final start = ZoneShift.shiftSeasonStart(now.year, range.startMonth, zone);
    // Still within reach this year if the window hasn't started yet or
    // we're currently inside it.
    if (!start.isBefore(now) || range.includes(now.month)) {
      return now.year;
    }
  }
  // No window applies (or all have passed) — if the plant carries no
  // datable windows at all we keep the current year, matching the
  // generic "i säsong" handling elsewhere.
  final hasAnyWindow = ranges.any((r) => r != null);
  return hasAnyWindow ? now.year + 1 : now.year;
}

