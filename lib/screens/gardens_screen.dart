import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/garden.dart';
import '../services/garden_service.dart';
import '../utils/swedish_zones.dart';

/// Manages the user's gardens — typically the balcony, the colony plot
/// and the country house. Reachable from Inställningar; also surfaced
/// implicitly by the garden-switcher popover in the app bar of any
/// content tab.
class GardensScreen extends StatelessWidget {
  const GardensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gardensTitle)),
      body: Consumer<GardenService>(
        builder: (ctx, garden, _) {
          final all = garden.gardens;
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              for (final g in all) _GardenCard(garden: g),
              const SizedBox(height: 12),
              _AddButton(onTap: () => _showEditor(context, null)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.gardensFooterHint,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF5A5A5A),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GardenCard extends StatelessWidget {
  final Garden garden;
  const _GardenCard({required this.garden});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final svc = context.read<GardenService>();
    final isActive = svc.activeGardenId == garden.id;
    final plantCount =
        svc.allPlants.where((p) => p.gardenId == garden.id).length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isActive ? const Color(0xFFEFF6E5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await svc.setActiveGarden(garden.id);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF558B2F)
                    : const Color(0xFFEDEDE2),
                width: isActive ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Text(garden.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              garden.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2A1A),
                              ),
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF558B2F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.gardensActive,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.gardensCityFormat(
                          garden.city ?? l10n.gardensNoLocation,
                          l10n.gardensZoneLine(garden.zone.toString()),
                        ),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.gardensPlantCount(plantCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showActions(context, garden),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showActions(BuildContext context, Garden g) async {
    final l10n = AppLocalizations.of(context);
    final svc = context.read<GardenService>();
    final canDelete = svc.gardens.length > 1;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.gardensEdit),
              onTap: () => Navigator.pop(ctx, 'edit'),
            ),
            if (canDelete)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red.shade700),
                title: Text(l10n.gardensDelete,
                    style: TextStyle(color: Colors.red.shade700)),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    if (action == 'edit') {
      await _showEditor(context, g);
    } else if (action == 'delete') {
      if (!context.mounted) return;
      await _confirmDelete(context, g);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Garden g) async {
    final l10n = AppLocalizations.of(context);
    final svc = context.read<GardenService>();
    final plantCount =
        svc.allPlants.where((p) => p.gardenId == g.id).length;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.gardensDeleteTitle(g.name)),
        content: Text(plantCount == 0
            ? l10n.gardensDeletePlainBody
            : l10n.gardensDeleteWithPlantsBody(plantCount)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.gardensCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.gardensDelete,
                style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await svc.deleteGarden(g.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }
}

Future<void> _showEditor(BuildContext context, Garden? existing) async {
  final l10n = AppLocalizations.of(context);
  final svc = context.read<GardenService>();
  final cityController =
      TextEditingController(text: existing?.city ?? '');
  String name = existing?.name ?? '';
  String emoji = existing?.emoji ?? '🌿';
  String? city = existing?.city;
  int zone = existing?.zone ?? 3;
  double? lat = existing?.lat;
  double? lon = existing?.lon;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
      final cities = SwedishZones.cityCoords.keys.toList()..sort();
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              existing == null
                  ? l10n.gardensNewTitle
                  : l10n.gardensEditTitle(existing.name),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: TextEditingController(text: name)
                ..selection = TextSelection.collapsed(offset: name.length),
              autofocus: existing == null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.gardensNameLabel,
                hintText: l10n.gardensNamePlaceholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 12),
            // Emoji picker
            Wrap(
              spacing: 8,
              children: [
                for (final e in const ['🌿', '🌷', '🥕', '🍓', '🌳', '🏡',
                  '🌻', '🍅', '🪴'])
                  ChoiceChip(
                    label: Text(e, style: const TextStyle(fontSize: 18)),
                    selected: emoji == e,
                    onSelected: (_) => setState(() => emoji = e),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // City picker — autocomplete-style dropdown
            DropdownButtonFormField<String>(
              initialValue: city,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.gardensCityLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: cities
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                final coords = SwedishZones.cityCoords[v]!;
                setState(() {
                  city = v;
                  lat = coords.$1;
                  lon = coords.$2;
                  zone = SwedishZones.zoneForLatitude(coords.$1);
                  cityController.text = v;
                });
              },
            ),
            const SizedBox(height: 8),
            Builder(builder: (_) {
              final desc = SwedishZones.zoneDescription(zone);
              final zoneText = l10n.gardensZoneLine(zone.toString());
              return Text(
                desc.isEmpty
                    ? zoneText
                    : l10n.gardensZoneDescription(zone.toString(), desc),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              );
            }),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF558B2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (name.trim().isEmpty) return;
                  if (existing == null) {
                    await svc.createGarden(
                      name: name.trim(),
                      emoji: emoji,
                      lat: lat,
                      lon: lon,
                      city: city,
                      zone: zone,
                    );
                  } else {
                    await svc.updateGarden(existing.copyWith(
                      name: name.trim(),
                      emoji: emoji,
                      lat: lat,
                      lon: lon,
                      city: city,
                      zone: zone,
                    ));
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(
                  existing == null
                      ? l10n.gardensCreateButton
                      : l10n.gardensSaveButton,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF558B2F),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline,
                  color: Color(0xFF558B2F), size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.gardensAddNew,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF558B2F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
