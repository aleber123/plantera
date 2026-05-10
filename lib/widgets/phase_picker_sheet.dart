import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/garden_plant.dart';
import '../models/plant.dart';
import '../services/ui_settings_service.dart';

/// Result returned when the user picks a phase / status.
/// [date] is null only when [status] is [PlantStatus.planerad] (no real
/// sowing date yet — it's just on the wishlist).
class PhasePick {
  final PlantStatus status;
  final DateTime? date;
  const PhasePick(this.status, this.date);
}

/// Bottom sheet used both at add-time ("var är du i processen?") and on
/// the plant detail screen ("ändra status"). Surfaces a small set of
/// statuses an older user actually thinks in: planerar, växer, skördad —
/// with a "fler alternativ"-toggle for the seven-state lifecycle that
/// power users want.
///
/// In simple mode (default, controlled by [UISettingsService.simpleStatus]):
///   - Planerar att odla
///   - Växer (auto-picks förodlad/direktsådd/utplanterad based on date)
///   - Skördad (or ändå klar)
///
/// In detailed mode the original 4-7 options are shown.
class PhasePickerSheet extends StatefulWidget {
  final String plantName;
  final PlantStatus? current;
  final bool includeFinishedStatuses;
  /// Optional. When supplied we pivot the option list for non-annual
  /// lifecycles — perennials/trees/shrubs that the user has already
  /// had for years should NOT be asked to pick a planting date.
  final PlantLifecycle? lifecycle;

  const PhasePickerSheet({
    super.key,
    required this.plantName,
    this.current,
    this.includeFinishedStatuses = false,
    this.lifecycle,
  });

  /// Convenience launcher — returns null if the user dismisses the sheet
  /// without picking. Caller dispatches based on result.
  static Future<PhasePick?> show(
    BuildContext context, {
    required String plantName,
    PlantStatus? current,
    bool includeFinishedStatuses = false,
    PlantLifecycle? lifecycle,
  }) {
    return showModalBottomSheet<PhasePick>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => PhasePickerSheet(
        plantName: plantName,
        current: current,
        includeFinishedStatuses: includeFinishedStatuses,
        lifecycle: lifecycle,
      ),
    );
  }

  @override
  State<PhasePickerSheet> createState() => _PhasePickerSheetState();
}

class _PhasePickerSheetState extends State<PhasePickerSheet> {
  /// User-overridden expansion just for this sheet — independent of
  /// the global UISettingsService.simpleStatus preference. Lets a
  /// power user keep simple-default but expand when needed.
  bool _expanded = false;

  List<_PhaseOption> _simpleItems(AppLocalizations l10n) => [
        _PhaseOption(
          status: PlantStatus.planerad,
          title: l10n.phaseSimplePlanned,
          body: l10n.phaseSimplePlannedBody,
          requiresDate: false,
        ),
        // We use forsoddInne as the "växer"-default because most users
        // start indoors. The sowing-method picker on the detail screen
        // lets them flip to direkt or planta after.
        _PhaseOption(
          status: PlantStatus.forsoddInne,
          title: l10n.phaseSimpleGrowing,
          body: l10n.phaseSimpleGrowingBody,
          requiresDate: true,
        ),
        _PhaseOption(
          status: PlantStatus.skordad,
          title: l10n.phaseSimpleHarvested,
          body: l10n.phaseSimpleHarvestedBody,
          requiresDate: false,
        ),
      ];

  /// Perennials, fruit trees and shrubs — plants that live for years.
  List<_PhaseOption> _perennialItems(AppLocalizations l10n) => [
        _PhaseOption(
          status: PlantStatus.utplanterad,
          title: l10n.phasePerennialHaveIt,
          body: l10n.phasePerennialHaveItBody,
          requiresDate: false,
        ),
        _PhaseOption(
          status: PlantStatus.planerad,
          title: l10n.phasePerennialPlanning,
          body: l10n.phasePerennialPlanningBody,
          requiresDate: false,
        ),
      ];

  List<_PhaseOption> _detailedItems(AppLocalizations l10n) => [
        _PhaseOption(
          status: PlantStatus.planerad,
          title: l10n.phaseDetailedPlanned,
          body: l10n.phaseDetailedPlannedBody,
          requiresDate: false,
        ),
        _PhaseOption(
          status: PlantStatus.forsoddInne,
          title: l10n.phaseDetailedPresow,
          body: l10n.phaseDetailedPresowBody,
          requiresDate: true,
        ),
        _PhaseOption(
          status: PlantStatus.direktsadd,
          title: l10n.phaseDetailedDirectsow,
          body: l10n.phaseDetailedDirectsowBody,
          requiresDate: true,
        ),
        _PhaseOption(
          status: PlantStatus.utplanterad,
          title: l10n.phaseDetailedPlantout,
          body: l10n.phaseDetailedPlantoutBody,
          requiresDate: true,
        ),
      ];

  List<_PhaseOption> _finishedItems(AppLocalizations l10n) => [
        _PhaseOption(
          status: PlantStatus.skordeklar,
          title: l10n.phaseFinishedReady,
          body: l10n.phaseFinishedReadyBody,
          requiresDate: false,
        ),
        _PhaseOption(
          status: PlantStatus.skordad,
          title: l10n.phaseFinishedHarvested,
          body: l10n.phaseFinishedHarvestedBody,
          requiresDate: false,
        ),
        _PhaseOption(
          status: PlantStatus.vilande,
          title: l10n.phaseFinishedDormant,
          body: l10n.phaseFinishedDormantBody,
          requiresDate: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ui = context.watch<UISettingsService>();
    final useSimple = ui.simpleStatus && !_expanded;
    final isPerennial = widget.lifecycle == PlantLifecycle.perennial ||
        widget.lifecycle == PlantLifecycle.tree ||
        widget.lifecycle == PlantLifecycle.shrub;

    final all = isPerennial
        // Perennials/trees: skip the entire date-driven flow. Even in
        // "fler alternativ"-mode there's nothing for the user to
        // configure beyond "have I planted it" — annual phases
        // (förodlar, härdar av) just don't apply.
        ? _perennialItems(l10n)
        : useSimple
            ? _simpleItems(l10n)
            : [
                ..._detailedItems(l10n),
                if (widget.includeFinishedStatuses)
                  ..._finishedItems(l10n),
              ];
    final isChange = widget.current != null;
    return SafeArea(
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
              isChange ? l10n.phasePickerTitleEdit : l10n.phasePickerTitleNew,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.plantName,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            for (final option in all)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OptionTile(
                  option: option,
                  selected: widget.current == option.status,
                  onTap: () => _pick(context, option),
                ),
              ),
            // "Fler alternativ"-toggle är inte relevant för perenner/
            // träd – det finns bara två meningsfulla val för dem.
            if (ui.simpleStatus && !isPerennial)
              TextButton.icon(
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(_expanded
                    ? Icons.unfold_less
                    : Icons.unfold_more),
                label: Text(_expanded
                    ? l10n.phaseShowSimple
                    : l10n.phaseShowMore),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, _PhaseOption option) async {
    DateTime? date;

    // Perennial / tree / shrub flow: instead of asking a precise day
    // (which the user doesn't remember for a jordgubbsplanta från 2019),
    // ask "när hamnade den i trädgården?" with chip-style options
    // ranging from "i år" to "äldre". Maps to a representative date
    // that the rest of the app can use.
    final isPerennialEstablished = (widget.lifecycle ==
                PlantLifecycle.perennial ||
            widget.lifecycle == PlantLifecycle.tree ||
            widget.lifecycle == PlantLifecycle.shrub) &&
        option.status == PlantStatus.utplanterad;

    if (isPerennialEstablished) {
      date = await _pickEstablishedYear(context);
      if (date == null) return;
    } else if (option.requiresDate) {
      final l10n = AppLocalizations.of(context);
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        helpText: switch (option.status) {
          PlantStatus.forsoddInne => l10n.phaseDateHelpPresow,
          PlantStatus.direktsadd => l10n.phaseDateHelpDirectsow,
          PlantStatus.utplanterad => l10n.phaseDateHelpPlantout,
          _ => l10n.phaseDateHelpDefault,
        },
      );
      if (picked == null) return;
      date = picked;
    }
    if (!context.mounted) return;
    Navigator.of(context).pop(PhasePick(option.status, date));
  }

  /// Quick year-picker for established perennials. Returns a sentinel
  /// date (Jan 1 of the chosen year) — precision finer than year is
  /// useless for plants you've had since 2019.
  Future<DateTime?> _pickEstablishedYear(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final thisYear = now.year;
    return showModalBottomSheet<DateTime>(
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
                l10n.phasePerennialYearTitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.phasePerennialYearBody,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 14),
              for (final y in [
                (
                  l10n.phasePerennialYearThis(thisYear.toString()),
                  DateTime(thisYear, now.month, now.day)
                ),
                (
                  l10n.phasePerennialYearLast((thisYear - 1).toString()),
                  DateTime(thisYear - 1, 6, 1)
                ),
                (
                  l10n.phasePerennialYearTwo((thisYear - 2).toString()),
                  DateTime(thisYear - 2, 6, 1)
                ),
                (l10n.phasePerennialYearOlder, DateTime(thisYear - 5, 6, 1)),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => Navigator.of(ctx).pop(y.$2),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE6E6DC)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            y.$1,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right,
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
  }
}

class _PhaseOption {
  final PlantStatus status;
  final String title;
  final String body;
  final bool requiresDate;
  const _PhaseOption({
    required this.status,
    required this.title,
    required this.body,
    required this.requiresDate,
  });
}

class _OptionTile extends StatelessWidget {
  final _PhaseOption option;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6E5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF558B2F)
                : const Color(0xFFE6E6DC),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(option.status.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          option.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(Icons.check_circle,
                            color: Color(0xFF558B2F), size: 20),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact summary that callers can drop into snackbars, e.g.
/// "Markerad som Förodlas (1 mar)".
String describePick(PhasePick pick, {String? localeName}) {
  if (pick.date == null) return pick.status.label;
  return '${pick.status.label} (${DateFormat('d MMM', localeName).format(pick.date!)})';
}
