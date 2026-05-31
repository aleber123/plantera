/// A plant the user *intends* to grow this season but hasn't actually
/// planted yet. Acts as a wishlist + planting calendar feeder:
///
/// 1. User taps "lägg till i säsong" on a plant in the database
/// 2. App schedules planting reminders based on `forsadatum` /
///    `direktsadatum` for [seasonYear]
/// 3. When the planting window arrives, user converts the wishlist item
///    into a real [GardenPlant] via the standard add-to-garden flow,
///    and the wishlist row is deleted
///
/// Persisted in its own SQLite table — separate from `garden_plants` so
/// "min trädgård just nu" and "min säsong" don't bleed into each other.
class WishlistPlant {
  final String id;
  final String plantId;

  /// Calendar year the user is planning for. Defaults to the current
  /// year when added; stored explicitly so a wishlist created in
  /// December for "next spring" doesn't disappear at year-flip.
  final int seasonYear;

  /// Free-text note ("rabatt vid förrådet", "20 plantor till morfar"…).
  /// Optional.
  final String? note;
  final DateTime addedAt;
  /// Which garden this wish is for (multi-trädgård, schema v4).
  /// Nullable for legacy rows from before the migration ran.
  final String? gardenId;

  const WishlistPlant({
    required this.id,
    required this.plantId,
    required this.seasonYear,
    this.note,
    required this.addedAt,
    this.gardenId,
  });

  WishlistPlant copyWith({String? note, int? seasonYear, String? gardenId}) =>
      WishlistPlant(
        id: id,
        plantId: plantId,
        seasonYear: seasonYear ?? this.seasonYear,
        note: note ?? this.note,
        addedAt: addedAt,
        gardenId: gardenId ?? this.gardenId,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'plant_id': plantId,
        'season_year': seasonYear,
        'note': note,
        'added_at': addedAt.millisecondsSinceEpoch,
        'garden_id': gardenId,
      };

  factory WishlistPlant.fromMap(Map<String, Object?> m) => WishlistPlant(
        id: m['id'] as String,
        plantId: m['plant_id'] as String,
        seasonYear: m['season_year'] as int,
        note: m['note'] as String?,
        addedAt:
            DateTime.fromMillisecondsSinceEpoch(m['added_at'] as int),
        gardenId: m['garden_id'] as String?,
      );

  /// Earliest sensible sowing date for this wish, given the plant's
  /// `forsadatum` (indoor pre-sow) and the user's zone. Returns the
  /// indoor pre-sow date if defined (most reliable anchor), otherwise
  /// the direct-sow date, otherwise null.
  ///
  /// Lets the UI surface "Sow around <date>" next to each wishlist
  /// entry — previously the user had to open the plant detail screen
  /// to find that out, which defeated the season planner's purpose.
  ///
  /// Pass in the plant lookup and the user's zone — this helper is
  /// model-side so it can be called from any screen without injecting
  /// services.
  DateTime? suggestedSowDate({
    required DateTime Function(int year, int month) zoneShifted,
    required int? indoorStartMonth,
    required int? directStartMonth,
  }) {
    final m = indoorStartMonth ?? directStartMonth;
    if (m == null) return null;
    return zoneShifted(seasonYear, m);
  }
}
