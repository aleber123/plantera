/// Lifecycle state for a plant in the user's garden. Drives which
/// notifications fire and what UI affordances appear.
///
/// Migration note: legacy `forsadd` rows (DB schema v3 and earlier) are
/// remapped to [forsoddInne] on load — see [PlantStatus.fromString].
enum PlantStatus {
  /// On the wishlist / added but not yet sown.
  planerad,

  /// Sown indoors in pots (windowsill, propagator).
  forsoddInne,

  /// Sown directly outdoors at its growing position.
  direktsadd,

  /// Indoor-sown plants being hardened off (transition between inside
  /// and final outdoor position).
  hardad,

  /// Final position outdoors — actively growing.
  utplanterad,

  /// Mature / fruit ready to pick.
  skordeklar,

  /// Harvested for this season.
  skordad,

  /// Overwintering or paused (perennials, garlic, etc.).
  vilande;

  String get label => switch (this) {
        PlantStatus.planerad => 'Planerar',
        PlantStatus.forsoddInne => 'Förodlar inomhus',
        PlantStatus.direktsadd => 'Direktsådd ute',
        PlantStatus.hardad => 'Härdar av',
        PlantStatus.utplanterad => 'Står ute',
        PlantStatus.skordeklar => 'Skördeklar',
        PlantStatus.skordad => 'Skördad',
        PlantStatus.vilande => 'Vilande',
      };

  /// Emoji shown in status pickers / chips. Visual hook so older users
  /// don't have to read every label. Universal symbols only — the old
  /// `skordeklar = 🥕` only made sense for root vegetables, jarring on
  /// tomatoes or jordgubbar.
  String get emoji => switch (this) {
        PlantStatus.planerad => '📅',
        PlantStatus.forsoddInne => '🌱',
        PlantStatus.direktsadd => '🌾',
        PlantStatus.hardad => '🌤️',
        PlantStatus.utplanterad => '🪴',
        PlantStatus.skordeklar => '🌟',
        PlantStatus.skordad => '✅',
        PlantStatus.vilande => '😴',
      };

  /// True when the plant is "in progress" — sown/planted but not yet
  /// harvested. Used by frost/heatwave notifications to filter to plants
  /// that actually need protecting outdoors.
  bool get isOutdoorActive => switch (this) {
        PlantStatus.direktsadd ||
        PlantStatus.hardad ||
        PlantStatus.utplanterad ||
        PlantStatus.skordeklar =>
          true,
        _ => false,
      };

  /// Parses a stored status string. Falls back to [planerad] for unknown
  /// values, and remaps the legacy `forsadd` value (renamed to
  /// `forsoddInne` in schema v4) to keep older rows working.
  static PlantStatus fromString(String s) {
    if (s == 'forsadd') return PlantStatus.forsoddInne;
    return PlantStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => PlantStatus.planerad,
    );
  }
}

/// How the user is sowing this plant. Decided when the plant is added
/// to the garden (or set later in the edit screen). Determines whether
/// the indoor-sowing or direct-sowing branch of notifications fires —
/// previously the system queued both phases for `planerad` plants.
enum SowingMethod {
  /// Sown indoors first, hardened off, then planted out.
  inomhus,

  /// Direct-sown into the growing position outdoors.
  direkt,

  /// Bought as a young plant — skips sowing entirely, goes straight to
  /// planting out at its window.
  planta;

  String get label => switch (this) {
        SowingMethod.inomhus => 'Förså inomhus',
        SowingMethod.direkt => 'Direktså ute',
        SowingMethod.planta => 'Köpt planta',
      };

  String get emoji => switch (this) {
        SowingMethod.inomhus => '🪟',
        SowingMethod.direkt => '🌾',
        SowingMethod.planta => '🛒',
      };

  static SowingMethod fromString(String? s) =>
      SowingMethod.values.firstWhere(
        (e) => e.name == s,
        orElse: () => SowingMethod.inomhus,
      );
}

class GardenNote {
  final String id;
  final DateTime date;
  final String text;
  final String? photoPath;

  const GardenNote({
    required this.id,
    required this.date,
    required this.text,
    this.photoPath,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.millisecondsSinceEpoch,
        'text': text,
        'photo_path': photoPath,
      };

  factory GardenNote.fromMap(Map<String, dynamic> m) => GardenNote(
        id: m['id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
        text: m['text'] as String,
        photoPath: m['photo_path'] as String?,
      );
}

class GardenPlant {
  final String id;
  final String plantId;
  final String? customName;
  final DateTime plantedDate;
  final String? location;
  final PlantStatus status;
  final SowingMethod sowingMethod;
  final int quantity;
  final DateTime? lastWatered;
  final List<GardenNote> notes;
  final DateTime createdAt;
  final String? heroPhotoPath;
  /// Foreign key into the gardens table (multi-trädgård, schema v4).
  /// Null only on rows from a pre-v4 install that hasn't migrated yet.
  final String? gardenId;

  /// User-applied adjustment to the auto-computed harvest date.
  /// Positive = "skörd är försenad, lägg till X dagar". Negative
  /// = "den växer snabbare än vi trodde". Defaults to 0. The
  /// progress-bar logic adds this on top of plant.dagarTillSkord
  /// for annuals or on top of skördeperiod-anchored date for
  /// perennials/trees.
  final int harvestOffsetDays;

  GardenPlant({
    required this.id,
    required this.plantId,
    this.customName,
    required this.plantedDate,
    this.location,
    this.status = PlantStatus.planerad,
    this.sowingMethod = SowingMethod.inomhus,
    this.quantity = 1,
    this.lastWatered,
    this.notes = const [],
    required this.createdAt,
    this.heroPhotoPath,
    this.gardenId,
    this.harvestOffsetDays = 0,
  });

  GardenPlant copyWith({
    String? customName,
    DateTime? plantedDate,
    String? location,
    PlantStatus? status,
    SowingMethod? sowingMethod,
    int? quantity,
    DateTime? lastWatered,
    List<GardenNote>? notes,
    String? heroPhotoPath,
    bool clearHeroPhoto = false,
    bool clearLocation = false,
    String? gardenId,
    int? harvestOffsetDays,
  }) =>
      GardenPlant(
        id: id,
        plantId: plantId,
        customName: customName ?? this.customName,
        plantedDate: plantedDate ?? this.plantedDate,
        location: clearLocation ? null : (location ?? this.location),
        status: status ?? this.status,
        sowingMethod: sowingMethod ?? this.sowingMethod,
        quantity: quantity ?? this.quantity,
        lastWatered: lastWatered ?? this.lastWatered,
        notes: notes ?? this.notes,
        createdAt: createdAt,
        heroPhotoPath:
            clearHeroPhoto ? null : (heroPhotoPath ?? this.heroPhotoPath),
        gardenId: gardenId ?? this.gardenId,
        harvestOffsetDays: harvestOffsetDays ?? this.harvestOffsetDays,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'plant_id': plantId,
        'custom_name': customName,
        'planted_date': plantedDate.millisecondsSinceEpoch,
        'location': location,
        'status': status.name,
        'sowing_method': sowingMethod.name,
        'quantity': quantity,
        'last_watered': lastWatered?.millisecondsSinceEpoch,
        'created_at': createdAt.millisecondsSinceEpoch,
        'hero_photo_path': heroPhotoPath,
        'garden_id': gardenId,
        'harvest_offset_days': harvestOffsetDays,
      };

  factory GardenPlant.fromMap(Map<String, dynamic> m,
          {List<GardenNote> notes = const []}) =>
      GardenPlant(
        id: m['id'] as String,
        plantId: m['plant_id'] as String,
        customName: m['custom_name'] as String?,
        plantedDate:
            DateTime.fromMillisecondsSinceEpoch(m['planted_date'] as int),
        location: m['location'] as String?,
        status: PlantStatus.fromString(m['status'] as String),
        sowingMethod: SowingMethod.fromString(m['sowing_method'] as String?),
        quantity: m['quantity'] as int? ?? 1,
        lastWatered: m['last_watered'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(m['last_watered'] as int),
        notes: notes,
        createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
        heroPhotoPath: m['hero_photo_path'] as String?,
        gardenId: m['garden_id'] as String?,
        harvestOffsetDays: m['harvest_offset_days'] as int? ?? 0,
      );
}
