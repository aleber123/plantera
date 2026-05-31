import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../screens/paywall_screen.dart';
import '../services/garden_service.dart';
import '../services/premium_service.dart';

/// Premium one-tap "Vattna alla utomhus-växter" flow. Lives in Att göra-
/// fliken so it sits next to the rest of the user's daily tasks rather
/// than in My Garden's AppBar where the icon was easy to miss.
Future<void> waterAllOutdoorPlants(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final premium = context.read<PremiumService>();
  final garden = context.read<GardenService>();

  if (!premium.isPremium) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => const PaywallScreen(source: 'water_all')),
    );
    return;
  }

  final outdoor =
      garden.plants.where((g) => g.status.isOutdoorActive).toList();
  if (outdoor.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.myGardenNoOutdoorPlants)),
    );
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.myGardenWaterAllTitle),
      content: Text(l10n.myGardenWaterAllConfirm(outdoor.length.toString())),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.myGardenWaterAllCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
          ),
          child: Text(l10n.myGardenWaterAllAction),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  HapticFeedback.mediumImpact();
  for (final gp in outdoor) {
    await garden.markWatered(gp.id);
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.myGardenWaterAllDone(outdoor.length.toString())),
    ),
  );
}
