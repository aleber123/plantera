import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/garden.dart';
import '../services/garden_service.dart';
import '../services/geocoding_service.dart';
import '../utils/climate_zones.dart';
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
            // Global city search — covers everything from Stockholm to
            // Sydney. Falls back to the Swedish-city quick-pick chips
            // below for users without internet or who just want one
            // tap.
            _CitySearchField(
              initialCity: city,
              swedishCities: cities,
              onSelected: (cityName, latVal, lonVal) {
                setState(() {
                  city = cityName;
                  lat = latVal;
                  lon = lonVal;
                  // Re-derive Swedish-zone equivalent. For coords inside
                  // Sweden this is exact; outside it's the closest USDA
                  // crosswalk back into the Sweden-calibrated scale.
                  if (latVal >= 54 &&
                      latVal <= 70 &&
                      lonVal >= 8 &&
                      lonVal <= 28) {
                    zone = SwedishZones.zoneForLatitude(latVal);
                  } else {
                    final profile =
                        ClimateProfile.fromCoordinates(latVal, lonVal);
                    zone = profile.swedishZoneEquivalent;
                  }
                  cityController.text = cityName;
                });
              },
            ),
            const SizedBox(height: 8),
            Builder(builder: (_) {
              // Show the right zone label for the picked location: USDA
              // outside Sweden, växtzon inside.
              if (lat != null && lon != null) {
                final profile =
                    ClimateProfile.fromCoordinates(lat!, lon!);
                if (profile.isOutsideSweden) {
                  final minC = profile.usdaZone.minTempC.round();
                  final hemi = profile.hemisphere == Hemisphere.south
                      ? ' · södra halvklotet'
                      : '';
                  return Text(
                    '${profile.usdaZone.label} – vinter ≈ $minC°C$hemi',
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade700),
                  );
                }
              }
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
            // Manual zone slider — for users who know their zone better
            // than our latitude approximation does. Range 1-8 in Swedish
            // terms (we don't expose a separate USDA slider; the
            // crosswalk handles the translation).
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.tune, size: 16, color: Color(0xFF6D7378)),
                const SizedBox(width: 8),
                Text('Justera zon manuellt',
                    style: TextStyle(
                        fontSize: 12.5, color: Colors.grey.shade700)),
                const Spacer(),
                Text('Zon $zone',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            Slider(
              value: zone.toDouble(),
              min: 1,
              max: 8,
              divisions: 7,
              label: 'Zon $zone',
              onChanged: (v) => setState(() => zone = v.round()),
            ),
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

/// Inline city search that hits Open-Meteo's geocoding API on debounce.
/// First shows Swedish quick-pick chips so existing users keep their
/// one-tap flow; typing into the field switches into global search.
class _CitySearchField extends StatefulWidget {
  final String? initialCity;
  final List<String> swedishCities;
  final void Function(String city, double lat, double lon) onSelected;
  const _CitySearchField({
    required this.initialCity,
    required this.swedishCities,
    required this.onSelected,
  });

  @override
  State<_CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<_CitySearchField> {
  late final TextEditingController _ctl;
  Timer? _debounce;
  List<GeocodedPlace> _results = const [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _ctl = TextEditingController(text: widget.initialCity ?? '');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    setState(() {});
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      if (v.trim().length < 2) {
        setState(() => _results = const []);
        return;
      }
      setState(() => _searching = true);
      final r = await GeocodingService.search(v);
      if (!mounted) return;
      setState(() {
        _results = r;
        _searching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _ctl.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _ctl,
          onChanged: _onChanged,
          decoration: InputDecoration(
            labelText: 'Stad eller ort',
            hintText: 'Stockholm, Berlin, Sydney…',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: hasQuery
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _ctl.clear();
                      setState(() => _results = const []);
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            isDense: true,
          ),
        ),
        if (_searching)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        if (!_searching && _results.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEDEDE2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final r = _results[i];
                final profile = ClimateProfile.fromCoordinates(r.lat, r.lon);
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(r.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${[r.admin1, r.country].whereType<String>().join(', ')} · ${profile.usdaZone.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    _ctl.text = r.name;
                    setState(() => _results = const []);
                    widget.onSelected(r.name, r.lat, r.lon);
                  },
                );
              },
            ),
          ),
        ],
        // Swedish quick-pick chips below the search box — still the
        // fastest path for the bulk of users who actually live in
        // Sweden and don't want to type.
        if (!hasQuery) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in widget.swedishCities)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _ctl.text == c,
                      onSelected: (_) {
                        final coords = SwedishZones.cityCoords[c]!;
                        _ctl.text = c;
                        widget.onSelected(c, coords.$1, coords.$2);
                      },
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
