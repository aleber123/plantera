import '../models/garden_plant.dart';
import '../models/plant.dart';
import 'zone_shift.dart';

/// Computed progress through a plant's grow cycle. The interpretation of
/// "progress" depends on [Plant.livscykel]:
///
/// - **annual / biennial**: linear progress from `plantedDate` toward
///   `plantedDate + dagarTillSkord` — what most users mean by "growing".
/// - **perennial**: progress within the *current* season, anchored on
///   the plant's `skordeperiod` start month. A rabarber planted three
///   years ago should show "Snart skörd" each May, not "+1095 days".
/// - **tree / shrub**: long-lived; no meaningful day-counter exists, so
///   we expose `hasData == false` and the UI surfaces upcoming
///   [CareTask] reminders instead of a bar.
///
/// All harvest-window computations are zone-shifted via [ZoneShift] so a
/// jordgubbe in Skåne reports earlier than the same plant in Norrland.
class GardenProgress {
  /// 0.0 = just planted (or season not started), 1.0 = harvest day or later.
  final double fraction;

  /// Days left until expected harvest. Negative means we're past it.
  /// Null when no day-counter applies (trees/shrubs, or annuals without
  /// `dagarTillSkord`).
  final int? daysLeft;

  /// Total days in the cycle. Null when not applicable.
  final int? totalDays;

  /// Estimated harvest date. Null when no harvest is expected this year.
  final DateTime? harvestDate;

  /// Trees and shrubs deliberately have no progress bar. The detail screen
  /// shows "Kommande omsorg" instead. Splitting this out keeps card/detail
  /// rendering simple — they branch on [showProgressBar] rather than
  /// reasoning about lifecycle directly.
  final bool suppressBar;

  const GardenProgress({
    required this.fraction,
    this.daysLeft,
    this.totalDays,
    this.harvestDate,
    this.suppressBar = false,
  });

  bool get hasData => totalDays != null;
  bool get isReady => hasData && fraction >= 1.0;
  bool get showProgressBar => hasData && !suppressBar;

  static const _suppressed =
      GardenProgress(fraction: 0, suppressBar: true);

  factory GardenProgress.compute(
    GardenPlant gp,
    Plant plant, {
    DateTime? now,
    required int zone,
  }) {
    final today = now ?? DateTime.now();

    // Annuals & biennials use planted-date + dagarTillSkord — that's
    // the timeline the user has in mind.
    if (plant.livscykel == PlantLifecycle.annual ||
        plant.livscykel == PlantLifecycle.biennial) {
      return _computeAnnual(gp, plant, today, zone);
    }

    // Perennials / trees / shrubs WITH a harvest period use the
    // season-based ramp: jordgubbe (perennial), äpple (tree),
    // hallon (shrub) all show "X dagar till skörd" anchored on the
    // zone-adjusted skordeperiod start. Long-lived plants without a
    // skördeperiod (e.g. ornamental rosor) suppress the bar — their
    // detail screen surfaces care tasks instead.
    if (plant.skordeperiod != null) {
      return _computePerennial(plant, gp, today, zone);
    }
    return _suppressed;
  }

  /// Annuals & biennials: progress is the elapsed fraction of
  /// [Plant.dagarTillSkord] since the user's actual planting date.
  /// Zone shift is applied to the *planting* date implicitly — annuals
  /// are usually planted at the right local time anyway, so the count
  /// to harvest just runs forward from when it actually went in.
  static GardenProgress _computeAnnual(
      GardenPlant gp, Plant plant, DateTime today, int zone) {
    final total = plant.dagarTillSkord;
    if (total == null || total <= 0) {
      return _zero;
    }
    // User-applied offset moves the harvest date forward (positive) or
    // backward (negative). Bar-fraction follows the adjusted total so
    // a plant nudged "+10 days" doesn't suddenly jump to 110%.
    final adjustedTotal = (total + gp.harvestOffsetDays).clamp(1, 10000);
    final harvest = gp.plantedDate.add(Duration(days: adjustedTotal));
    final elapsed = today.difference(gp.plantedDate).inDays;
    final raw = elapsed / adjustedTotal;
    final clamped = raw.isNaN ? 0.0 : raw.clamp(0.0, 1.0);
    return GardenProgress(
      fraction: clamped,
      totalDays: adjustedTotal,
      daysLeft: harvest.difference(today).inDays,
      harvestDate: harvest,
    );
  }

  /// Perennials: anchor progress on the harvest window for the *current*
  /// year, shifted by the user's zone. A jordgubbsplanta in Skåne (zone
  /// 1) ripens ~2 weeks earlier than the database default (zone 3).
  /// The user-applied [GardenPlant.harvestOffsetDays] nudges the
  /// anchored start so päron som mognar senare än vanligt går att
  /// kalibrera in.
  static GardenProgress _computePerennial(
      Plant plant, GardenPlant gp, DateTime today, int zone) {
    final harvestRange = plant.skordeperiod;
    if (harvestRange == null) {
      return _zero;
    }
    var harvestStart =
        ZoneShift.shiftSeasonStart(today.year, harvestRange.startMonth, zone)
            .add(Duration(days: gp.harvestOffsetDays));
    if (today.isAfter(harvestStart) &&
        !harvestRange.includes(today.month)) {
      harvestStart = ZoneShift.shiftSeasonStart(
              today.year + 1, harvestRange.startMonth, zone)
          .add(Duration(days: gp.harvestOffsetDays));
    }
    const seasonRamp = 90;
    final start = harvestStart.subtract(const Duration(days: seasonRamp));
    final elapsed = today.difference(start).inDays;
    final raw = elapsed / seasonRamp;
    final clamped = raw.isNaN ? 0.0 : raw.clamp(0.0, 1.0);
    return GardenProgress(
      fraction: clamped,
      totalDays: seasonRamp,
      daysLeft: harvestStart.difference(today).inDays,
      harvestDate: harvestStart,
    );
  }

  static const _zero = GardenProgress(fraction: 0);
}
