enum HarvestUnit {
  kg,
  g,
  st,
  liter;

  String get label => switch (this) {
        HarvestUnit.kg => 'kg',
        HarvestUnit.g => 'g',
        HarvestUnit.st => 'st',
        HarvestUnit.liter => 'liter',
      };

  static HarvestUnit fromString(String s) =>
      HarvestUnit.values.firstWhere((e) => e.name == s,
          orElse: () => HarvestUnit.kg);
}

class HarvestEntry {
  final String id;
  final String gardenPlantId;
  final DateTime date;
  final double amount;
  final HarvestUnit unit;
  final String? notes;

  const HarvestEntry({
    required this.id,
    required this.gardenPlantId,
    required this.date,
    required this.amount,
    required this.unit,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'garden_plant_id': gardenPlantId,
        'date': date.millisecondsSinceEpoch,
        'amount': amount,
        'unit': unit.name,
        'notes': notes,
      };

  factory HarvestEntry.fromMap(Map<String, dynamic> m) => HarvestEntry(
        id: m['id'] as String,
        gardenPlantId: m['garden_plant_id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
        amount: (m['amount'] as num).toDouble(),
        unit: HarvestUnit.fromString(m['unit'] as String),
        notes: m['notes'] as String?,
      );
}
