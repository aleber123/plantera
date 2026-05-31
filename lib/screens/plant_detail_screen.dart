import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../services/affiliate_service.dart';
import '../services/garden_service.dart';
import '../services/notification_service.dart';
import '../services/premium_service.dart';
import '../services/zone_service.dart';
import '../utils/add_to_garden.dart';
import '../utils/garden_progress.dart';
import '../utils/zone_shift.dart';
import '../widgets/affiliate_card.dart';
import '../widgets/harvest_section.dart';
import '../widgets/phase_picker_sheet.dart';
import '../widgets/plant_hero_avatar.dart';
import 'circle_crop_screen.dart';
import 'paywall_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;
  final GardenPlant? gardenPlant;
  const PlantDetailScreen({super.key, required this.plant, this.gardenPlant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  Plant get plant => widget.plant;
  GardenPlant? get gardenPlant => widget.gardenPlant;

  bool get _hasPlanting => gardenPlant != null;

  @override
  void initState() {
    super.initState();
    // When the user already owns this plant, default to "Min plantering"
    // — that's the surface they care about. Generic plant info under
    // "Översikt" is mostly relevant during discovery, not after.
    _tabs = TabController(
      length: _hasPlanting ? 3 : 2,
      vsync: this,
      initialIndex: _hasPlanting ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gp = gardenPlant;
    return Scaffold(
      appBar: AppBar(
        title: Text('${gp?.customName ?? plant.namnSv} ${plant.emoji}'),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: false,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.plantDetailTabOverview),
            if (_hasPlanting) Tab(text: l10n.plantDetailTabMyPlant),
            Tab(text: l10n.plantDetailTabCare),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _OverviewTab(plant: plant, gardenPlant: gp),
          if (_hasPlanting) _MyPlantingTab(plant: plant, gardenPlant: gp!),
          _CareTab(plant: plant),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Plant plant;
  final GardenPlant? gardenPlant;
  const _OverviewTab({required this.plant, this.gardenPlant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zone = context.watch<ZoneService>();
    final gp = gardenPlant;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _HeaderBanner(plant: plant, gardenPlant: gp),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.namnLat,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 16),
              Text(plant.beskrivning,
                  style: const TextStyle(fontSize: 16, height: 1.5)),
              if (gp != null) ...[
                const SizedBox(height: 20),
                _HarvestProgressCard(gp: gp, plant: plant),
              ],
              const SizedBox(height: 24),
              _InfoGrid(plant: plant),
              const SizedBox(height: 24),
              _SeasonTimeline(plant: plant),
              if (!plant.zoner.contains(zone.zone)) ...[
                const SizedBox(height: 20),
                _ZoneWarning(zone: zone.zone),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: gp == null
                    ? ElevatedButton.icon(
                        onPressed: () => _addToGarden(context),
                        icon: const Icon(Icons.add, size: 22),
                        label: Text(l10n.plantDetailAddCta),
                      )
                    : OutlinedButton.icon(
                        onPressed: () => _confirmRemove(context, gp),
                        icon: Icon(Icons.delete_outline,
                            color: Colors.red.shade700, size: 22),
                        label: Text(
                          l10n.plantDetailRemoveCta,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade300, width: 1.5),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addToGarden(BuildContext context) =>
      addPlantToGarden(context, plant);

  Future<void> _confirmRemove(BuildContext context, GardenPlant gp) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.plantDetailRemoveTitle),
        content: Text(l10n.plantDetailRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.plantDetailCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.plantDetailDelete,
                style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final garden = context.read<GardenService>();
    final notifications = context.read<NotificationService>();
    await notifications.cancelForGardenPlant(gp.id);
    await garden.remove(gp.id);
    if (context.mounted) Navigator.pop(context);
  }
}

/// "Min plantering"-tabben — användarens specifika instans av växten.
/// Layout har en konsekvent vertikal rytm: hero → primär CTA → daglig
/// rad → omsorg → dagbok → skörd → sekundära actions. Varje sektion är
/// ett kort med samma styling, vilket ger ögat ett stadigt ankare.
class _MyPlantingTab extends StatelessWidget {
  final Plant plant;
  final GardenPlant gardenPlant;
  const _MyPlantingTab({required this.plant, required this.gardenPlant});

  @override
  Widget build(BuildContext context) {
    return Consumer<GardenService>(
      builder: (ctx, garden, _) {
        // Re-read by id so updates (hero photo, status, location, notes)
        // flow into the tree without manual setState.
        final gp = garden.plants
                .where((g) => g.id == gardenPlant.id)
                .firstOrNull ??
            gardenPlant;
        // Skördekortet är inte alltid relevant — perenner som inte har
        // skördeperiod (t.ex. blommor odlade för utseendet) eller en
        // växt på "planerar"-stadiet bör inte trycka "Logga skörd" på
        // användaren.
        final showHarvest = gp.status != PlantStatus.planerad &&
            (plant.skordeperiod != null || plant.dagarTillSkord != null);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _PlantingHero(plant: plant, gp: gp),
            const SizedBox(height: 14),
            _NextStepCta(plant: plant, gp: gp),
            _DailyActionsRow(plant: plant, gp: gp),
            const SizedBox(height: 14),
            _UpcomingCareForPlant(plant: plant),
            const SizedBox(height: 14),
            _PlantingJournal(plant: plant, gp: gp),
            if (showHarvest) ...[
              const SizedBox(height: 14),
              _PlantingSection(
                title: AppLocalizations.of(context).plantDetailHarvestSection,
                child: HarvestSection(
                  gardenPlantId: gp.id,
                  plantName: gp.customName ?? plant.namnSv,
                  plant: plant,
                ),
              ),
            ],
            const SizedBox(height: 14),
            _SecondaryActions(plant: plant, gp: gp),
          ],
        );
      },
    );
  }
}

/// Wraps a section's content with the standard card chrome so every
/// block on the tab looks like a sibling instead of a different
/// component.
class _PlantingSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _PlantingSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDE2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D5016),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Top hero — combined photo/emoji + status + planted-date + location
/// in a single card. Replaces the old separate "Lägg till bild"-section
/// and "Status banner" so the user only sees their plant once.
///
/// Tap on the avatar = pick or change the hero photo. No separate
/// "Byt bild"-button anymore — discoverability via gentle hint label
/// when no photo is set.
class _PlantingHero extends StatefulWidget {
  final Plant plant;
  final GardenPlant gp;
  const _PlantingHero({required this.plant, required this.gp});

  @override
  State<_PlantingHero> createState() => _PlantingHeroState();
}

class _PlantingHeroState extends State<_PlantingHero> {
  final _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pickAndCrop(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 2400,
        maxHeight: 2400,
        imageQuality: 92,
      );
      if (picked == null) return;
      if (!mounted) return;
      final cropped = await Navigator.of(context).push<File>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => CircleCropScreen(source: File(picked.path)),
        ),
      );
      if (cropped == null || !mounted) return;
      await context
          .read<GardenService>()
          .setHeroPhoto(widget.gp.id, cropped.path);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(l10n.plantDetailSaveImageError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showAvatarMenu() async {
    final l10n = AppLocalizations.of(context);
    // Photo features are Premium per the paywall ("Fotodagbok för
    // varje växt"). Send free users to the paywall instead of letting
    // them silently bypass the gate.
    final premium = context.read<PremiumService>();
    if (!premium.canUsePhotoLog) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => const PaywallScreen(source: 'photo_log')),
      );
      return;
    }
    final hasPhoto = widget.gp.heroPhotoPath != null;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.plantDetailTakePhoto),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.plantDetailPickLibrary),
              onTap: () => Navigator.pop(ctx, 'library'),
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(l10n.plantDetailUseEmojiAgain),
                onTap: () => Navigator.pop(ctx, 'reset'),
              ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    if (action == 'camera') await _pickAndCrop(ImageSource.camera);
    if (action == 'library') await _pickAndCrop(ImageSource.gallery);
    if (action == 'reset') {
      if (!mounted) return;
      await context.read<GardenService>().setHeroPhoto(widget.gp.id, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final gp = widget.gp;
    final plant = widget.plant;
    final hasPhoto = gp.heroPhotoPath != null;
    final isPlanned = gp.status == PlantStatus.planerad;
    final isLongLived = plant.livscykel == PlantLifecycle.perennial ||
        plant.livscykel.isLongLived;
    String dateLabel;
    final dateStr = DateFormat('d MMM y', localeName).format(gp.plantedDate);
    if (isPlanned) {
      dateLabel = l10n.plantDetailDateAdded(dateStr);
    } else if (isLongLived) {
      dateLabel = l10n.plantDetailDateInGardenSince(
          gp.plantedDate.year.toString());
    } else {
      dateLabel = l10n.plantDetailDatePlanted(dateStr);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6E5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCDE0AB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tappable hero photo. Stack adds a small camera affordance so
          // the user understands it's interactive even when no photo is
          // set yet — emoji alone reads as "decorative".
          Stack(
            children: [
              GestureDetector(
                onTap: _busy ? null : _showAvatarMenu,
                child: PlantHeroAvatar(
                  heroPhotoPath: gp.heroPhotoPath,
                  fallbackEmoji: plant.emoji,
                  size: 88,
                ),
              ),
              if (!_busy)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF558B2F),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      hasPhoto ? Icons.edit : Icons.add_a_photo,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              if (_busy)
                const Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(gp.status.emoji,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        gp.status.label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2A1A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  dateLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                  ),
                ),
                if ((gp.location ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.place_rounded,
                          size: 13, color: Colors.grey.shade700),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          gp.location!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (gp.quantity > 1) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${gp.quantity} st',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One primary CTA — what should the user do next? When there's no
/// natural next step (skördad / vilande / freshly-planted seed that
/// needs to grow), the whole card hides.
class _NextStepCta extends StatelessWidget {
  final Plant plant;
  final GardenPlant gp;
  const _NextStepCta({required this.plant, required this.gp});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zone = context.select<ZoneService, int>((z) => z.zone);
    final next = _nextStepForStatus(l10n, plant, gp, zone);
    if (next == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 14),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF558B2F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => _advanceTo(
            context,
            plant,
            gp,
            next.target,
            askDate: next.askDate,
          ),
          icon: const Icon(Icons.check_circle_outline, size: 22),
          label: Text(
            next.label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

/// Daily-use bar — vattnad nu + add-note shortcut. Always visible
/// because these are the actions a gardener does most often.
class _DailyActionsRow extends StatelessWidget {
  final Plant plant;
  final GardenPlant gp;
  const _DailyActionsRow({required this.plant, required this.gp});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final waterLabel = _wateredLabel(context, gp.lastWatered);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDE2)),
      ),
      child: Row(
        children: [
          const Text('💧', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waterLabel,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2A1A),
                  ),
                ),
                if (gp.lastWatered == null)
                  Text(
                    l10n.plantDetailWaterTapHint,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => _markWatered(context, gp),
            icon: const Icon(Icons.water_drop_outlined, size: 18),
            label: Text(l10n.plantDetailWaterNowSuffix),
          ),
        ],
      ),
    );
  }
}

/// Care tasks for THIS specific plant — filtered from plant.omsorg by
/// upcoming month so the user sees what to do next without scanning a
/// general list. Hides entirely when the plant has no omsorg data.
class _UpcomingCareForPlant extends StatelessWidget {
  final Plant plant;
  const _UpcomingCareForPlant({required this.plant});

  @override
  Widget build(BuildContext context) {
    if (plant.omsorg.isEmpty) return const SizedBox.shrink();
    final now = DateTime.now();
    // Sort tasks by days-until-next-occurrence so the most urgent is
    // first. A task currently active gets daysLeft = 0.
    final ranked = plant.omsorg.map((task) {
      final daysLeft = _daysUntilMonth(task.month.startMonth, now);
      return (task: task, daysLeft: daysLeft);
    }).toList()
      ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

    final l10n = AppLocalizations.of(context);
    return _PlantingSection(
      title: l10n.plantDetailUpcomingCareTitle,
      child: Column(
        children: [
          for (final entry in ranked.take(3))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.task.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2A1A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.daysLeft == 0
                                  ? l10n.plantDetailDueNow
                                  : entry.daysLeft <= 30
                                      ? '${entry.daysLeft} dgr'
                                      : '${(entry.daysLeft / 30).round()} mån',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: entry.daysLeft <= 14
                                    ? const Color(0xFFE65100)
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.task.description,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.35,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (plant.omsorg.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '+${plant.omsorg.length - 3} fler omsorgs-tillfällen',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Vertical journal that mixes photos and text notes chronologically —
/// a real growing diary. Replaces the horizontal-only photo timeline
/// since text-only entries ("bladlöss på undersidan av blad", "första
/// blomman idag") are equally valuable.
class _PlantingJournal extends StatefulWidget {
  final Plant plant;
  final GardenPlant gp;
  const _PlantingJournal({required this.plant, required this.gp});

  @override
  State<_PlantingJournal> createState() => _PlantingJournalState();
}

class _PlantingJournalState extends State<_PlantingJournal> {
  final _picker = ImagePicker();
  bool _busy = false;

  Future<void> _addPhoto(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(docs.path, 'garden_photos'));
      if (!dir.existsSync()) dir.createSync(recursive: true);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(picked.path).isEmpty
          ? '.jpg'
          : p.extension(picked.path);
      final dest = p.join(dir.path, '${widget.gp.id}_$ts$ext');
      await File(picked.path).copy(dest);
      if (!mounted) return;
      await context
          .read<GardenService>()
          .addNote(widget.gp.id, '', photoPath: dest);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(l10n.plantDetailSavePhotoError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addNote() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
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
              l10n.plantDetailNoteTitle,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.plantDetailNoteSubtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 4,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.plantDetailNoteHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Spacer(),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(ctx).pop(controller.text.trim()),
                  child: Text(l10n.plantDetailSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (text == null || text.isEmpty || !mounted) return;
    await context.read<GardenService>().addNote(widget.gp.id, text);
  }

  Future<void> _showAddSheet() async {
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.plantDetailTakePhoto),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.plantDetailPickLibrary),
              onTap: () => Navigator.pop(ctx, 'library'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: Text(l10n.plantDetailWriteNote),
              onTap: () => Navigator.pop(ctx, 'note'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    // Photo-attaching is Premium ("Fotodagbok" on paywall). Notes are
    // free. Send free users picking a photo option to the paywall.
    if (action == 'camera' || action == 'library') {
      final premium = context.read<PremiumService>();
      if (!premium.canUsePhotoLog) {
        await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => const PaywallScreen(source: 'photo_log')),
        );
        return;
      }
    }
    if (action == 'camera') await _addPhoto(ImageSource.camera);
    if (action == 'library') await _addPhoto(ImageSource.gallery);
    if (action == 'note') await _addNote();
  }

  Future<void> _confirmDelete(GardenNote note) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(note.photoPath != null
            ? l10n.plantDetailDeletePhotoTitle
            : l10n.plantDetailDeleteNoteTitle),
        content: Text(note.photoPath != null
            ? l10n.plantDetailDeletePhotoBody
            : l10n.plantDetailDeleteNoteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.plantDetailCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.plantDetailDelete,
                style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    if (note.photoPath != null) {
      try {
        final f = File(note.photoPath!);
        if (f.existsSync()) await f.delete();
      } catch (_) {/* file already gone — proceed */}
    }
    if (!mounted) return;
    await context.read<GardenService>().deleteNote(note.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GardenService>(
      builder: (ctx, garden, _) {
        final gp = garden.plants
                .where((g) => g.id == widget.gp.id)
                .firstOrNull ??
            widget.gp;
        final entries = List<GardenNote>.from(gp.notes)
          ..sort((a, b) => b.date.compareTo(a.date));
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEDEDE2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '📓  DAGBOK',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D5016),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (entries.isNotEmpty)
                    Text(
                      '${entries.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _busy ? null : _showAddSheet,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          )
                        : const Icon(Icons.add, size: 18),
                    label: Text(AppLocalizations.of(context).plantDetailAdd),
                  ),
                ],
              ),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    AppLocalizations.of(context).plantDetailNoPostsBody,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (final note in entries)
                      _JournalEntry(
                        note: note,
                        onDelete: () => _confirmDelete(note),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _JournalEntry extends StatelessWidget {
  final GardenNote note;
  final VoidCallback onDelete;
  const _JournalEntry({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final dateLabel = DateFormat('d MMM', localeName).format(note.date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              dateLabel,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.photoPath != null)
                  GestureDetector(
                    onTap: () => _viewFullScreen(context, note),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(note.photoPath!),
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 80,
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (note.text.isNotEmpty) ...[
                  if (note.photoPath != null) const SizedBox(height: 6),
                  Text(
                    note.text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF1F2A1A),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Explicit menu — replaces the old discoverable-only
          // long-press. Same row as the timestamp so the affordance
          // is right next to the entry it acts on.
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade500, size: 20),
            visualDensity: VisualDensity.compact,
            tooltip: AppLocalizations.of(context).plantDetailEditPostsTooltip,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  void _viewFullScreen(BuildContext context, GardenNote note) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(DateFormat('d MMM y', localeName).format(note.date)),
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.file(File(note.photoPath!)),
          ),
        ),
      ),
    ));
  }
}

/// Discreet bottom row of edit-actions. Less prominent than the primary
/// CTA but still reachable. Includes status, sowing method, location,
/// and delete.
class _SecondaryActions extends StatelessWidget {
  final Plant plant;
  final GardenPlant gp;
  const _SecondaryActions({required this.plant, required this.gp});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPerennialOrTree = plant.livscykel == PlantLifecycle.perennial ||
        plant.livscykel.isLongLived;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => _changeStatusFlow(context, plant, gp),
          icon: const Icon(Icons.swap_horiz, size: 18),
          label: Text(l10n.plantDetailChangeStatus),
        ),
        // Sårmetod är inte relevant för perenner/träd — gömd där.
        if (!isPerennialOrTree)
          OutlinedButton.icon(
            onPressed: () => _changeSowingMethod(context, plant, gp),
            icon: Icon(_sowingIcon(gp.sowingMethod), size: 18),
            label: Text(l10n.plantDetailSowingMethodChip(
                gp.sowingMethod.label.toLowerCase())),
          ),
        OutlinedButton.icon(
          onPressed: () => _editLocation(context, gp),
          icon: const Icon(Icons.place_outlined, size: 18),
          label: Text((gp.location ?? '').isEmpty
              ? l10n.plantDetailLocationLabel
              : gp.location!),
        ),
        OutlinedButton.icon(
          onPressed: () => _adjustHarvestOffset(context, gp),
          icon: const Icon(Icons.tune, size: 18),
          label: Text(_harvestOffsetLabel(l10n, gp.harvestOffsetDays)),
        ),
        OutlinedButton.icon(
          onPressed: () => _confirmRemove(context, plant, gp),
          icon: Icon(Icons.delete_outline,
              size: 18, color: Colors.red.shade700),
          label: Text(l10n.plantDetailDelete,
              style: TextStyle(color: Colors.red.shade700)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.red.shade300),
          ),
        ),
      ],
    );
  }

  static String _harvestOffsetLabel(AppLocalizations l10n, int offset) {
    if (offset == 0) return l10n.plantDetailHarvestOffsetSubtitle;
    if (offset > 0) return 'Skörd +$offset dgr';
    return 'Skörd $offset dgr';
  }

  IconData _sowingIcon(SowingMethod m) => switch (m) {
        SowingMethod.inomhus => Icons.home_outlined,
        SowingMethod.direkt => Icons.grass_outlined,
        SowingMethod.planta => Icons.local_florist_outlined,
      };
}

// ── Action helpers ───────────────────────────────────────────────────
// Top-level (file-private) so any widget on the planting tab can invoke
// them without instantiating a banner class. Each one handles its own
// service look-ups, persistence, notification reschedule, and snack-bar
// feedback.

/// Suggested next action — single source of truth for the next-step
/// CTA. Returns null when there's no obvious move *right now*:
///   - skördad / vilande → terminal
///   - direktsadd / utplanterad → only suggest "Klar för skörd" when
///     the plant is genuinely close to harvest. A persilja sown today
///     in May should NOT see "Klar för skörd" just because May is in
///     the harvest window — that fired even though the plant has 74
///     days of growing left.
_NextStep? _nextStepForStatus(
    AppLocalizations l10n, Plant plant, GardenPlant gp, int zone) {
  final s = gp.status;
  switch (s) {
    case PlantStatus.planerad:
      switch (gp.sowingMethod) {
        case SowingMethod.inomhus:
          return _NextStep(l10n.plantDetailNextStepPresow,
              PlantStatus.forsoddInne, askDate: true);
        case SowingMethod.direkt:
          return _NextStep(l10n.plantDetailNextStepDirectsow,
              PlantStatus.direktsadd, askDate: true);
        case SowingMethod.planta:
          return _NextStep(l10n.plantDetailNextStepPlantout,
              PlantStatus.utplanterad,
              askDate: true);
      }
    case PlantStatus.forsoddInne:
    case PlantStatus.hardad:
      return _NextStep(l10n.plantDetailNextStepPlantedOut,
          PlantStatus.utplanterad,
          askDate: true);
    case PlantStatus.direktsadd:
    case PlantStatus.utplanterad:
      return _harvestReadyForCta(plant, gp, zone)
          ? _NextStep(
              l10n.plantDetailNextStepHarvestReady, PlantStatus.skordeklar)
          : null;
    case PlantStatus.skordeklar:
      return _NextStep(
          l10n.plantDetailNextStepHarvested, PlantStatus.skordad);
    case PlantStatus.skordad:
    case PlantStatus.vilande:
      return null;
  }
}

/// Mirrors the readiness logic in [InsightsService._harvestReady] so a
/// plant only reaches the "Klar för skörd"-CTA when it's actually close
/// to harvest. Zone-aware: harvest "starts" the database month, but the
/// effective start day is shifted by [ZoneShift.daysFor].
bool _harvestReadyForCta(Plant plant, GardenPlant gp, int zone) {
  final range = plant.skordeperiod;
  if (range == null) return false;
  final today = DateTime.now();
  final shiftedStart =
      ZoneShift.shiftSeasonStart(today.year, range.startMonth, zone);
  // We're in the active window if today is at or past the zone-shifted
  // start AND the database month range still says we're in season —
  // the latter prevents northern users from getting an autumn signal
  // when shiftedStart pushes into a month past slut_manad.
  final pastShiftedStart = !today.isBefore(shiftedStart);
  final stillInSeasonMonth = range.includes(today.month);
  if (!pastShiftedStart || !stillInSeasonMonth) return false;

  final lifecycle = plant.livscykel;
  if (lifecycle == PlantLifecycle.perennial ||
      lifecycle == PlantLifecycle.tree ||
      lifecycle == PlantLifecycle.shrub) {
    return true;
  }
  final plantedDay =
      DateTime(gp.plantedDate.year, gp.plantedDate.month, gp.plantedDate.day);
  final daysGrown = today.difference(plantedDay).inDays;
  if (plant.dagarTillSkord != null) {
    return daysGrown >= (plant.dagarTillSkord! * 0.8).round();
  }
  return daysGrown >= 30;
}

Future<void> _advanceTo(
  BuildContext context,
  Plant plant,
  GardenPlant gp,
  PlantStatus target, {
  bool askDate = false,
}) async {
  DateTime? date;
  if (askDate) {
    final l10n = AppLocalizations.of(context);
    date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      // Clamped to today: a future plantedDate breaks downstream date
      // math (negative daysGrown, water tasks never fire, harvest ETA
      // pushed past the season).
      lastDate: DateTime.now(),
      helpText: l10n.plantDetailDateHelp,
    );
    if (date == null || !context.mounted) return;
  }
  final garden = context.read<GardenService>();
  final notifications = context.read<NotificationService>();
  final zone = context.read<ZoneService>();
  final msg = ScaffoldMessenger.of(context);
  final newMethod = switch (target) {
    PlantStatus.direktsadd => SowingMethod.direkt,
    _ => gp.sowingMethod,
  };
  final updated = gp.copyWith(
    status: target,
    plantedDate: date ?? gp.plantedDate,
    sowingMethod: newMethod,
  );
  await garden.update(updated);
  await notifications.cancelForGardenPlant(gp.id);
  final scheduled = await notifications.scheduleAllForGardenPlant(
    gardenPlantId: updated.id,
    plant: plant,
    zone: zone.zone,
    status: updated.status,
    plantedDate: updated.plantedDate,
    sowingMethod: updated.sowingMethod,
  );
  final body = scheduled.isEmpty
      ? 'Markerad som ${target.label.toLowerCase()}'
      : 'Status: ${target.label.toLowerCase()} — påminnelser: ${scheduled.join(", ")}';
  msg.showSnackBar(SnackBar(content: Text(body)));
}

Future<void> _changeStatusFlow(
    BuildContext context, Plant plant, GardenPlant gp) async {
  final pick = await PhasePickerSheet.show(
    context,
    plantName: gp.customName ?? plant.namnSv,
    current: gp.status,
    includeFinishedStatuses: true,
    lifecycle: plant.livscykel,
  );
  if (pick == null || !context.mounted) return;
  final garden = context.read<GardenService>();
  final notifications = context.read<NotificationService>();
  final zone = context.read<ZoneService>();
  final msg = ScaffoldMessenger.of(context);
  final method = switch (pick.status) {
    PlantStatus.direktsadd => SowingMethod.direkt,
    PlantStatus.utplanterad => SowingMethod.planta,
    _ => gp.sowingMethod,
  };
  final updated = gp.copyWith(
    status: pick.status,
    plantedDate: pick.date ?? gp.plantedDate,
    sowingMethod: method,
  );
  await garden.update(updated);
  await notifications.cancelForGardenPlant(gp.id);
  final scheduled = await notifications.scheduleAllForGardenPlant(
    gardenPlantId: updated.id,
    plant: plant,
    zone: zone.zone,
    status: updated.status,
    plantedDate: updated.plantedDate,
    sowingMethod: updated.sowingMethod,
  );
  final body = scheduled.isEmpty
      ? 'Status ändrad till ${pick.status.label.toLowerCase()}'
      : 'Status ändrad – nya påminnelser: ${scheduled.join(", ")}';
  msg.showSnackBar(SnackBar(content: Text(body)));
}

Future<void> _changeSowingMethod(
    BuildContext context, Plant plant, GardenPlant gp) async {
  final picked = await showModalBottomSheet<SowingMethod>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
              AppLocalizations.of(ctx).plantDetailHowSowTitle,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(ctx).plantDetailHowSowBody,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            for (final m in SowingMethod.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => Navigator.of(ctx).pop(m),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: gp.sowingMethod == m
                          ? const Color(0xFFEFF6E5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: gp.sowingMethod == m
                            ? const Color(0xFF558B2F)
                            : const Color(0xFFE6E6DC),
                        width: gp.sowingMethod == m ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(m.emoji,
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m.label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (gp.sowingMethod == m)
                          const Icon(Icons.check_circle,
                              color: Color(0xFF558B2F)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
  if (picked == null || picked == gp.sowingMethod || !context.mounted) {
    return;
  }
  final garden = context.read<GardenService>();
  final notifications = context.read<NotificationService>();
  final zone = context.read<ZoneService>();
  final msg = ScaffoldMessenger.of(context);
  final updated = gp.copyWith(sowingMethod: picked);
  await garden.update(updated);
  await notifications.cancelForGardenPlant(gp.id);
  await notifications.scheduleAllForGardenPlant(
    gardenPlantId: updated.id,
    plant: plant,
    zone: zone.zone,
    status: updated.status,
    plantedDate: updated.plantedDate,
    sowingMethod: updated.sowingMethod,
  );
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  msg.showSnackBar(
    SnackBar(
        content: Text(l10n.plantDetailSowingMethodSnack(
            picked.label.toLowerCase()))),
  );
}

Future<void> _editLocation(BuildContext context, GardenPlant gp) async {
  final garden = context.read<GardenService>();
  final existing = <String>{};
  for (final g in garden.plants) {
    final l = (g.location ?? '').trim();
    if (l.isNotEmpty) existing.add(l);
  }
  final controller = TextEditingController(text: gp.location ?? '');
  final picked = await showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
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
            AppLocalizations.of(ctx).plantDetailLocationTitle,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(ctx).plantDetailLocationBody,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(ctx).plantDetailLocationLabel,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
          ),
          if (existing.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(ctx).plantDetailReuse,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final loc in existing.toList()..sort())
                  ActionChip(
                    label: Text(loc),
                    onPressed: () => Navigator.of(ctx).pop(loc),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              if ((gp.location ?? '').isNotEmpty)
                TextButton.icon(
                  onPressed: () => Navigator.of(ctx).pop(''),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(AppLocalizations.of(ctx).plantDetailDelete),
                ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.of(ctx).pop(controller.text.trim()),
                child: Text(AppLocalizations.of(ctx).plantDetailSave),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  if (picked == null || !context.mounted) return;
  final newValue = picked.isEmpty ? null : picked;
  if (newValue == gp.location) return;
  final updated = newValue == null
      ? gp.copyWith(clearLocation: true)
      : gp.copyWith(location: newValue);
  await garden.update(updated);
}

/// Bottom-sheet for nudging the auto-computed harvest date by ±N days.
/// Visual is a +/- stepper anchored on the current offset, so a user
/// who's previously bumped päron +14 doesn't have to re-enter the full
/// adjustment — they tweak from there. Persisted as
/// [GardenPlant.harvestOffsetDays].
Future<void> _adjustHarvestOffset(
    BuildContext context, GardenPlant gp) async {
  final garden = context.read<GardenService>();
  var offset = gp.harvestOffsetDays;
  final picked = await showModalBottomSheet<int>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
              const SizedBox(height: 14),
              Text(
                AppLocalizations.of(ctx).plantDetailHarvestOffsetTitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(ctx).plantDetailHarvestOffsetBody,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    onPressed: () =>
                        setState(() => offset = (offset - 7).clamp(-365, 365)),
                    icon: const Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF6E5),
                      foregroundColor: const Color(0xFF558B2F),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: Text(
                      offset == 0
                          ? '0 dgr'
                          : (offset > 0 ? '+$offset dgr' : '$offset dgr'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    onPressed: () =>
                        setState(() => offset = (offset + 7).clamp(-365, 365)),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF6E5),
                      foregroundColor: const Color(0xFF558B2F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  for (final d in const [-30, -14, -7, 0, 7, 14, 30])
                    ChoiceChip(
                      label: Text(d == 0
                          ? AppLocalizations.of(ctx).plantDetailReset
                          : (d > 0 ? '+$d' : '$d')),
                      selected: offset == d,
                      onSelected: (_) => setState(() => offset = d),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(null),
                      child: Text(AppLocalizations.of(ctx).plantDetailCancel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(offset),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF558B2F),
                      ),
                      child:
                          Text(AppLocalizations.of(ctx).plantDetailSave),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }),
  );
  if (picked == null) return;
  await garden.update(gp.copyWith(harvestOffsetDays: picked));
}

Future<void> _markWatered(BuildContext context, GardenPlant gp) async {
  final l10n = AppLocalizations.of(context);
  final garden = context.read<GardenService>();
  // Light haptic confirms the tap registered. Skips on Android web.
  HapticFeedback.lightImpact();
  await garden.markWatered(gp.id);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.plantDetailWaterDoneSnack)),
  );
}

Future<void> _confirmRemove(
    BuildContext context, Plant plant, GardenPlant gp) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.plantDetailRemoveTitle),
      content: Text(l10n.plantDetailRemoveBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.plantDetailCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.plantDetailDelete,
              style: TextStyle(color: Colors.red.shade700)),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  final garden = context.read<GardenService>();
  final notifications = context.read<NotificationService>();
  await notifications.cancelForGardenPlant(gp.id);
  await garden.remove(gp.id);
  if (context.mounted) Navigator.pop(context);
}

String _wateredLabel(BuildContext context, DateTime? lastWatered) {
  final l10n = AppLocalizations.of(context);
  if (lastWatered == null) return l10n.plantDetailWaterNotYet;
  final now = DateTime.now();
  final diff = now.difference(lastWatered);
  if (diff.inHours < 4) return l10n.plantDetailWaterJust;
  if (diff.inDays == 0) return l10n.plantDetailWaterToday;
  if (diff.inDays == 1) return l10n.plantDetailWaterYesterday;
  if (diff.inDays < 7) {
    return l10n.wateredDaysAgo(diff.inDays.toString());
  }
  return l10n.wateredWeeksAgo((diff.inDays / 7).round().toString());
}

int _daysUntilMonth(int targetMonth, DateTime now) {
  // Within the active month → 0 (treat as "due now").
  if (targetMonth == now.month) return 0;
  // Closest occurrence — this year if still upcoming, otherwise next.
  var target = DateTime(now.year, targetMonth, 1);
  if (target.isBefore(now)) {
    target = DateTime(now.year + 1, targetMonth, 1);
  }
  return target.difference(now).inDays;
}


/// Suggested next-step shown as a single big button on the status banner.
/// Encodes both the target state and whether the transition needs a
/// date input (e.g. "when did you sow it?").
class _NextStep {
  final String label;
  final PlantStatus target;
  final bool askDate;
  const _NextStep(this.label, this.target, {this.askDate = false});
}


/// Headline progress card on plant detail showing the time-to-harvest
/// bar with planted/harvest dates. Sits above the grow info so the
/// user immediately sees how far they are.
class _HarvestProgressCard extends StatelessWidget {
  final GardenPlant gp;
  final Plant plant;
  const _HarvestProgressCard({required this.gp, required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final zone = context.select<ZoneService, int>((z) => z.zone);
    final progress = GardenProgress.compute(gp, plant, zone: zone);
    if (!progress.showProgressBar) {
      final accent = Color(plant.kategori.accentArgb);
      final lifeLabel = plant.livscykel.isLongLived
          ? '${plant.livscykel.label} – ingen säsongsräknare, men du får påminnelser om beskärning, gödning m.m.'
          : l10n.plantDetailDatePlanted(
              DateFormat('d MMM', localeName).format(gp.plantedDate));
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Icon(
              plant.livscykel.isLongLived
                  ? Icons.park_rounded
                  : Icons.eco_outlined,
              size: 18,
              color: accent,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                lifeLabel,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2A1A),
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    }
    final accent = Color(plant.kategori.accentArgb);
    final harvest = progress.harvestDate!;
    final daysLeft = progress.daysLeft ?? 0;
    final headline = progress.isReady
        ? l10n.plantDetailReadyToHarvest
        : daysLeft <= 7
            ? '$daysLeft dagar till skörd'
            : '~$daysLeft dagar till skörd';
    final fmt = DateFormat('d MMM', localeName);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                progress.isReady
                    ? Icons.celebration_rounded
                    : Icons.eco_rounded,
                color: accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                headline,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress.fraction * 100).round()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.fraction,
              minHeight: 10,
              backgroundColor: accent.withValues(alpha: 0.18),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.plantDetailDatePlanted(fmt.format(gp.plantedDate)),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                'Skörd ~${fmt.format(harvest)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Översikt-tabbens widgets (åter-implementerade efter refactor) ────

/// Generisk växtfaktablads-flik. Visar instruktioner, tips, skadedjur
/// + affiliate-länkar för verktyg.
class _CareTab extends StatelessWidget {
  final Plant plant;
  const _CareTab({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasContent = plant.instruktioner != null ||
        plant.tips != null ||
        plant.skadedjur.isNotEmpty;
    return ListView(
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plant.instruktioner != null) ...[
                _SectionTitle('📘', l10n.plantDetailHowToTitle),
                Text(plant.instruktioner!,
                    style: const TextStyle(fontSize: 16, height: 1.55)),
                const SizedBox(height: 24),
              ],
              if (plant.tips != null) ...[
                _SectionTitle('💡', l10n.plantDetailTipsTitle),
                Text(plant.tips!,
                    style: const TextStyle(fontSize: 16, height: 1.55)),
                const SizedBox(height: 24),
              ],
              if (plant.skadedjur.isNotEmpty) ...[
                _SectionTitle('🐛', l10n.plantDetailPestsTitle),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: plant.skadedjur
                      .map((s) => Chip(
                            label: Text(s,
                                style: const TextStyle(fontSize: 14)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (!hasContent)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      l10n.plantDetailNoCareTips,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        AffiliateCard(
          title: l10n.plantDetailToolsSection,
          products: AffiliateService.productsForPlant(plant),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String label;
  const _SectionTitle(this.emoji, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2A1A),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient-banner ovanför Översikt-tabben. Använder kategorins
/// tint-/accent-färger så användaren kan känna igen typ av växt direkt.
class _HeaderBanner extends StatelessWidget {
  final Plant plant;
  final GardenPlant? gardenPlant;
  const _HeaderBanner({required this.plant, this.gardenPlant});

  @override
  Widget build(BuildContext context) {
    final tint = Color(plant.kategori.tintArgb);
    final accent = Color(plant.kategori.accentArgb);
    return Container(
      height: 170,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tint, accent.withValues(alpha: 0.55)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(plant.emoji,
                style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            Text(
              plant.kategori.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2x2-grid med växtens grundkrav: sol, vatten, gödsel, kallhet.
class _InfoGrid extends StatelessWidget {
  final Plant plant;
  const _InfoGrid({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tiles = <_InfoTile>[
      _InfoTile(
          icon: Icons.wb_sunny_outlined,
          label: l10n.plantDetailInfoSun,
          value: plant.solkrav.label),
      _InfoTile(
          icon: Icons.water_drop_outlined,
          label: l10n.plantDetailInfoWater,
          value: plant.vattning.label),
      _InfoTile(
          icon: Icons.eco_outlined,
          label: l10n.plantDetailInfoFertilizer,
          value: plant.godselbehov.label),
      if (plant.kallighetC != null)
        _InfoTile(
            icon: Icons.ac_unit,
            label: l10n.plantDetailInfoFrost,
            value: '${plant.kallighetC!.toStringAsFixed(0)}°C'),
      if (plant.avstandCm != null)
        _InfoTile(
            icon: Icons.straighten,
            label: l10n.plantDetailInfoSpacing,
            value: '${plant.avstandCm} cm'),
      if (plant.dagarTillSkord != null)
        _InfoTile(
            icon: Icons.schedule,
            label: l10n.plantDetailInfoHarvest,
            value: '${plant.dagarTillSkord} dagar'),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tiles
          .map((t) => SizedBox(
                width: (MediaQuery.of(context).size.width - 50) / 2,
                child: t,
              ))
          .toList(),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDE2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2A1A),
            ),
          ),
        ],
      ),
    );
  }
}

/// 12-månaders-tidslinje som visar förodling, direktsådd, utplantering
/// och skördeperiod som färgade band. Snabb visuell sammanfattning.
class _SeasonTimeline extends StatelessWidget {
  final Plant plant;
  const _SeasonTimeline({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phases = <(String, String, MonthRange?, Color)>[
      ('🏠', l10n.plantDetailPhasePresow,
          plant.forsadatum, const Color(0xFF8E24AA)),
      ('🌱', l10n.plantDetailPhaseDirectsow,
          plant.direktsadatum, const Color(0xFF558B2F)),
      ('🪴', l10n.plantDetailPhasePlantout,
          plant.utplanteringsdatum, const Color(0xFFEF6C00)),
      ('🥕', l10n.plantDetailPhaseHarvest,
          plant.skordeperiod, const Color(0xFFC62828)),
    ].where((e) => e.$3 != null).toList();
    if (phases.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('📅', l10n.plantDetailSeasonSection),
        for (final (emoji, label, range, color) in phases)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(label,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Expanded(
                  child: _MonthBar(range: range!, color: color),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Renders a 12-month bar with the active range highlighted.
class _MonthBar extends StatelessWidget {
  final MonthRange range;
  final Color color;
  const _MonthBar({required this.range, required this.color});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: 26,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final cellW = constraints.maxWidth / 12;
          return Stack(
            children: [
              // Background grid
              Row(
                children: List.generate(12, (i) {
                  return Container(
                    width: cellW,
                    height: 26,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade200,
                          width: i == 11 ? 0 : 1,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat.MMM(localeName)
                          .format(DateTime(DateTime.now().year, i + 1, 1))
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  );
                }),
              ),
              // Active range bar(s) — handle wrap-around (e.g. okt-feb).
              ..._activeRanges().map((r) {
                final left = (r.$1 - 1) * cellW;
                final width = (r.$2 - r.$1 + 1) * cellW;
                return Positioned(
                  left: left,
                  top: 4,
                  child: Container(
                    width: width,
                    height: 18,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  /// Splits a wrap-around range (e.g. start=10, end=2) into two segments.
  List<(int, int)> _activeRanges() {
    final s = range.startMonth;
    final e = range.endMonth;
    if (s <= e) return [(s, e)];
    return [(s, 12), (1, e)];
  }
}

/// Visas när användarens zon inte stöds av växten — ger kontext istället
/// för en hård "ej kompatibel"-blockering.
class _ZoneWarning extends StatelessWidget {
  final int zone;
  const _ZoneWarning({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8D26A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)
                  .plantDetailZoneWarning(zone.toString()),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A3B00),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
