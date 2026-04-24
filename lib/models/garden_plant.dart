enum PlantStatus {
  forsadd,
  utplanterad,
  skordeklar,
  vilande;

  String get label => switch (this) {
        PlantStatus.forsadd => 'Försådd',
        PlantStatus.utplanterad => 'Utplanterad',
        PlantStatus.skordeklar => 'Skördeklar',
        PlantStatus.vilande => 'Vilande',
      };

  static PlantStatus fromString(String s) =>
      PlantStatus.values.firstWhere((e) => e.name == s,
          orElse: () => PlantStatus.forsadd);
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
  final int quantity;
  final DateTime? lastWatered;
  final List<GardenNote> notes;
  final DateTime createdAt;

  GardenPlant({
    required this.id,
    required this.plantId,
    this.customName,
    required this.plantedDate,
    this.location,
    this.status = PlantStatus.forsadd,
    this.quantity = 1,
    this.lastWatered,
    this.notes = const [],
    required this.createdAt,
  });

  GardenPlant copyWith({
    String? customName,
    DateTime? plantedDate,
    String? location,
    PlantStatus? status,
    int? quantity,
    DateTime? lastWatered,
    List<GardenNote>? notes,
  }) =>
      GardenPlant(
        id: id,
        plantId: plantId,
        customName: customName ?? this.customName,
        plantedDate: plantedDate ?? this.plantedDate,
        location: location ?? this.location,
        status: status ?? this.status,
        quantity: quantity ?? this.quantity,
        lastWatered: lastWatered ?? this.lastWatered,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'plant_id': plantId,
        'custom_name': customName,
        'planted_date': plantedDate.millisecondsSinceEpoch,
        'location': location,
        'status': status.name,
        'quantity': quantity,
        'last_watered': lastWatered?.millisecondsSinceEpoch,
        'created_at': createdAt.millisecondsSinceEpoch,
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
        quantity: m['quantity'] as int? ?? 1,
        lastWatered: m['last_watered'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(m['last_watered'] as int),
        notes: notes,
        createdAt: DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
      );
}
