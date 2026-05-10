import '../models/harvest_entry.dart';
import '../models/plant.dart';

/// Rough Swedish supermarket prices for an estimated total value of the
/// year's harvest. Numbers are deliberately conservative — the goal is
/// to make the user feel proud of their garden, not to overstate. Picks
/// per (plantCategory, harvestUnit) so a kilo of bär (~120 kr) and a
/// kilo of root vegetables (~30 kr) don't end up at the same number.
///
/// These are not live market prices — that would mean a remote API
/// dependency for a number that's already an estimate. Static is fine.
class HarvestValue {
  /// Estimated value in SEK for [amount] of [unit] of a plant in
  /// [category]. Returns 0 for units we can't price (st/liter without a
  /// good per-unit anchor for that category).
  static double estimateSek(
    Plant plant,
    HarvestUnit unit,
    double amount,
  ) {
    final perKg = _kgPrice[plant.kategori] ?? 30.0;
    return switch (unit) {
      HarvestUnit.kg => amount * perKg,
      HarvestUnit.g => (amount / 1000) * perKg,
      // Per-piece prices vary wildly by plant. Use rough anchors per
      // category — most reasonable for berries and herbs where "antal"
      // makes sense.
      HarvestUnit.st => amount * (_perPiecePrice[plant.kategori] ?? 5.0),
      // Liter is mostly used for berries (jordgubbar i liter etc.).
      // Treat as ~0.6 kg per liter and use kg pricing.
      HarvestUnit.liter => amount * 0.6 * perKg,
    };
  }

  static const Map<PlantCategory, double> _kgPrice = {
    PlantCategory.gronsaker: 35.0,
    PlantCategory.kryddor: 200.0,
    PlantCategory.bar: 110.0,
    PlantCategory.frukttrad: 40.0,
    PlantCategory.blommor: 30.0,
    PlantCategory.ovriga: 30.0,
  };

  static const Map<PlantCategory, double> _perPiecePrice = {
    PlantCategory.gronsaker: 8.0,
    PlantCategory.kryddor: 15.0,
    PlantCategory.bar: 1.5,
    PlantCategory.frukttrad: 4.0,
    PlantCategory.blommor: 12.0,
    PlantCategory.ovriga: 5.0,
  };
}
