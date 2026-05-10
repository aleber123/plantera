import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../services/garden_service.dart';
import '../services/season_planner_service.dart';
import '../services/zone_service.dart';
import '../utils/add_to_garden.dart';
import '../utils/add_to_season.dart';
import '../utils/constants.dart';
import '../utils/garden_progress.dart';

/// Card widget used in plant database, search and calendar views.
///
/// Behaviors:
/// - Tapping the card body navigates to detail (caller-supplied [onTap]).
/// - The trailing `+` button quick-adds the plant to the garden via
///   [addPlantToGarden] without requiring a detour to the detail
///   screen. When the plant is already in the garden, the `+` is
///   replaced with a checkmark and the card grows a progress bar
///   showing days-until-harvest.
class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onTap;

  const PlantCard({super.key, required this.plant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tint = Color(plant.kategori.tintArgb);
    final accent = Color(plant.kategori.accentArgb);

    // Look up an existing GardenPlant for this plant. We listen on
    // GardenService so the card flips from "+" to "✓" as soon as the
    // user adds the plant — no manual reload.
    final gp = context.select<GardenService, GardenPlant?>(
      (g) => g.plants.where((p) => p.plantId == plant.id).firstOrNull,
    );
    final zone = context.select<ZoneService, int>((z) => z.zone);
    final progress =
        gp != null ? GardenProgress.compute(gp, plant, zone: zone) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEDEDE2), width: 1),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  tint.withValues(alpha: 0.55),
                  Colors.white,
                ],
                stops: const [0.0, 0.65],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _avatar(tint, accent),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.namnSv,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                              color: Color(0xFF1F2A1A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plant.namnLat,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _categoryChip(accent),
                              if (plant.dagarTillSkord != null)
                                _metaChip(
                                  Icons.schedule,
                                  '${plant.dagarTillSkord} dagar',
                                ),
                              _metaChip(Icons.eco_outlined, _bestMonth(plant)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _AddOrCheckButton(
                      plant: plant,
                      gp: gp,
                      accent: accent,
                    ),
                  ],
                ),
                if (progress != null && progress.showProgressBar) ...[
                  const SizedBox(height: 12),
                  _ProgressRow(progress: progress, accent: accent),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar(Color tint, Color accent) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [tint, tint.withValues(alpha: 0.4)],
          radius: 0.85,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        plant.emoji,
        style: const TextStyle(fontSize: 30),
      ),
    );
  }

  Widget _categoryChip(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        plant.kategori.label,
        style: TextStyle(
          fontSize: 11,
          color: accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E6DC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  String _bestMonth(Plant p) {
    final r = p.forsadatum ?? p.direktsadatum ?? p.utplanteringsdatum;
    if (r == null) return '—';
    return 'Så ${AppConstants.monthShortSv[r.startMonth]}';
  }
}

/// Trailing add-button. Three states:
///
/// - Plant in garden → checkmark.
/// - Plant on this year's wishlist → bookmark icon (still tap-to-remove
///   via menu, but visual signals "we know you want this").
/// - Neither → single + button that opens a menu with two clear options
///   ("Lägg till nu" vs "Lägg till i såningslistan").
///
/// Why a menu instead of two stacked buttons: the previous bookmark+plus
/// stack created beslutsångest — users tapped + expecting a menu, got
/// an immediate add. The menu is one extra tap but eliminates surprise.
class _AddOrCheckButton extends StatelessWidget {
  final Plant plant;
  final GardenPlant? gp;
  final Color accent;
  const _AddOrCheckButton({
    required this.plant,
    required this.gp,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    if (gp != null) {
      return Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_rounded, color: accent, size: 24),
      );
    }
    final onWishlist = context.select<SeasonPlannerService, bool>(
      (s) => s.contains(plant.id),
    );
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: onWishlist ? Colors.white : accent,
        shape: CircleBorder(
          side: onWishlist
              ? BorderSide(color: accent, width: 1.5)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _showAddMenu(context),
          child: Icon(
            onWishlist ? Icons.bookmark_rounded : Icons.add_rounded,
            color: onWishlist ? accent : Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }

  Future<void> _showAddMenu(BuildContext context) async {
    final onWishlist = context.read<SeasonPlannerService>().contains(plant.id);
    final action = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Text(plant.emoji,
                        style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        plant.namnSv,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF558B2F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_florist,
                      color: Colors.white),
                ),
                title: const Text('Lägg till i trädgården nu',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text(
                    'Du har sått eller planterat — vi följer den från idag'),
                onTap: () => Navigator.pop(ctx, 'now'),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: onWishlist
                        ? Colors.grey.shade400
                        : const Color(0xFFEF6C00),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    onWishlist
                        ? Icons.bookmark_remove
                        : Icons.bookmark_add,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  onWishlist
                      ? 'Ta bort från såningslistan'
                      : 'Lägg till i såningslistan',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  onWishlist
                      ? 'Vi slutar påminna om sånings-fönstret'
                      : 'Du planerar att odla — vi pingar när det är dags att så',
                ),
                onTap: () => Navigator.pop(ctx, 'season'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    if (action == 'now') {
      await addPlantToGarden(context, plant);
    } else if (action == 'season') {
      if (!context.mounted) return;
      await toggleSeasonWishlist(context, plant);
    }
  }
}

/// Visual progress bar shown beneath the row when the plant is in
/// the garden. Communicates "X days planted, Y days until harvest"
/// with a clear horizontal bar so users see at a glance how close
/// they are.
class _ProgressRow extends StatelessWidget {
  final GardenProgress progress;
  final Color accent;
  const _ProgressRow({required this.progress, required this.accent});

  @override
  Widget build(BuildContext context) {
    final daysLeft = progress.daysLeft ?? 0;
    final label = progress.isReady
        ? 'Redo att skördas'
        : daysLeft <= 7
            ? '$daysLeft dagar till skörd'
            : '~$daysLeft dagar till skörd';
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                progress.isReady
                    ? Icons.celebration_rounded
                    : Icons.eco_rounded,
                size: 13,
                color: accent,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress.fraction * 100).round()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.fraction,
              minHeight: 6,
              backgroundColor: accent.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }
}
