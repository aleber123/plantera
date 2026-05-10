import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/plant.dart';
import '../models/wishlist_plant.dart';
import '../services/notification_service.dart';
import '../services/season_planner_service.dart';
import '../services/zone_service.dart';

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
  final year = DateTime.now().year;

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

