import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../screens/main_shell.dart';
import '../services/garden_service.dart';
import '../services/notification_service.dart';
import '../services/zone_service.dart';
import '../widgets/phase_picker_sheet.dart';

/// Shared flow for adding a plant to the user's garden. Used from
/// both PlantCard's quick-add `+` and PlantDetailScreen's full button
/// so the experience is identical regardless of entry point.
///
/// Shows the phase-picker bottom sheet, persists the GardenPlant via
/// [GardenService], schedules notifications via [NotificationService]
/// and surfaces a SnackBar with the result.
///
/// Returns the new [GardenPlant] when added, or null if the user
/// dismissed the picker.
Future<GardenPlant?> addPlantToGarden(
    BuildContext context, Plant plant) async {
  final pick = await PhasePickerSheet.show(
    context,
    plantName: plant.namnSv,
    lifecycle: plant.livscykel,
  );
  if (pick == null || !context.mounted) return null;

  final garden = context.read<GardenService>();
  final notifications = context.read<NotificationService>();
  final zone = context.read<ZoneService>();

  // Infer sowingMethod from the user's status pick. If they say
  // "förodlar inomhus" the method is implicitly inomhus; "direktsått"
  // implies direkt; everything else defaults to inomhus (the safer
  // default since it queues fewer phases).
  final method = switch (pick.status) {
    PlantStatus.direktsadd => SowingMethod.direkt,
    PlantStatus.utplanterad => SowingMethod.planta,
    _ => SowingMethod.inomhus,
  };

  final gp = await garden.add(
    plantId: plant.id,
    status: pick.status,
    sowingMethod: method,
    plantedDate: pick.date,
  );
  final scheduled = await notifications.scheduleAllForGardenPlant(
    gardenPlantId: gp.id,
    plant: plant,
    zone: zone.zone,
    status: pick.status,
    plantedDate: gp.plantedDate,
    sowingMethod: gp.sowingMethod,
  );
  // Reward haptic — adding a plant is a celebration moment, deserves
  // a stronger physical confirmation than a quiet snackbar.
  HapticFeedback.mediumImpact();

  if (!context.mounted) return gp;

  // Show a brief confirmation dialog rather than a tiny snackbar so
  // the user actually feels the plant was added. Auto-dismisses.
  await _showAddedDialog(context, plant: plant, scheduled: scheduled);
  if (!context.mounted) return gp;

  // Pop any open routes (plant detail, picker sheets) and switch to
  // the "Min trädgård"-tab so the user sees their new plant land
  // among the existing ones.
  Navigator.of(context).popUntil((r) => r.isFirst);
  if (!context.mounted) return gp;
  MainShellController.of(context)?.goToTab(3);

  // First impression matters: after the 3rd plant the user has clearly
  // committed to the app. Apple's review API rate-limits to 3
  // prompts/year and silently no-ops if shown too often, so we don't
  // need our own backoff beyond the "shown once"-flag.
  unawaited(_maybeRequestReview(garden.plantCount));
  return gp;
}

Future<void> _maybeRequestReview(int plantCount) async {
  if (plantCount < 3) return;
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('rated_prompt_shown') == true) return;
  final inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    await prefs.setBool('rated_prompt_shown', true);
    await inAppReview.requestReview();
  }
}

Future<void> _showAddedDialog(
  BuildContext context, {
  required Plant plant,
  required List<String> scheduled,
}) async {
  final l10n = AppLocalizations.of(context);
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(plant.emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              l10n.addedToGardenTitle(plant.namnSv),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              scheduled.isEmpty
                  ? l10n.addedToGardenBodyPlain
                  : l10n.addedToGardenBodyScheduled(
                      scheduled.join(', ').toLowerCase()),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF558B2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  l10n.addedToGardenCta,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
