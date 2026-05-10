/// One physical garden the user manages — typically the **balkong**,
/// **kolonilotten**, or **landstället**. Each has its own zone and
/// coordinates because Sweden's micro-climates differ enough that a
/// single zone-shift doesn't cover all three places someone might own.
///
/// Plants, harvests and the season-planner wishlist are all scoped to
/// a single garden via the active-garden state in
/// [GardenManagementService]. This keeps "Min trädgård just nu"-vyn
/// focused on what's actually in front of you when you walk out.
class Garden {
  final String id;
  final String name;
  final String emoji;
  final double? lat;
  final double? lon;
  final String? city;
  /// Swedish hardiness zone (1 = warmest, 8 = coldest).
  final int zone;
  /// True for the row that should be active on first launch / when the
  /// active-garden preference is missing. Exactly one row should have
  /// this set; the management service enforces.
  final bool isDefault;
  final DateTime createdAt;

  const Garden({
    required this.id,
    required this.name,
    required this.emoji,
    this.lat,
    this.lon,
    this.city,
    required this.zone,
    this.isDefault = false,
    required this.createdAt,
  });

  Garden copyWith({
    String? name,
    String? emoji,
    double? lat,
    double? lon,
    String? city,
    int? zone,
    bool? isDefault,
  }) =>
      Garden(
        id: id,
        name: name ?? this.name,
        emoji: emoji ?? this.emoji,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        city: city ?? this.city,
        zone: zone ?? this.zone,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'lat': lat,
        'lon': lon,
        'city': city,
        'zone': zone,
        'is_default': isDefault ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Garden.fromMap(Map<String, Object?> m) => Garden(
        id: m['id'] as String,
        name: m['name'] as String,
        emoji: m['emoji'] as String? ?? '🌱',
        lat: (m['lat'] as num?)?.toDouble(),
        lon: (m['lon'] as num?)?.toDouble(),
        city: m['city'] as String?,
        zone: m['zone'] as int? ?? 3,
        isDefault: (m['is_default'] as int? ?? 0) == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            m['created_at'] as int? ?? 0),
      );
}
