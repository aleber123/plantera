class MonthRange {
  final int startMonth;
  final int endMonth;
  const MonthRange(this.startMonth, this.endMonth);

  bool includes(int month) {
    if (startMonth <= endMonth) {
      return month >= startMonth && month <= endMonth;
    }
    return month >= startMonth || month <= endMonth;
  }

  static MonthRange? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return MonthRange(
      json['start_manad'] as int,
      json['slut_manad'] as int,
    );
  }
}

enum PlantCategory {
  gronsaker,
  kryddor,
  blommor,
  bar,
  frukttrad,
  ovriga;

  String get label => switch (this) {
        PlantCategory.gronsaker => 'Grönsaker',
        PlantCategory.kryddor => 'Kryddor & örter',
        PlantCategory.blommor => 'Blommor',
        PlantCategory.bar => 'Bär',
        PlantCategory.frukttrad => 'Fruktträd',
        PlantCategory.ovriga => 'Övrigt',
      };

  String get emoji => switch (this) {
        PlantCategory.gronsaker => '🥕',
        PlantCategory.kryddor => '🌿',
        PlantCategory.blommor => '🌸',
        PlantCategory.bar => '🫐',
        PlantCategory.frukttrad => '🍎',
        PlantCategory.ovriga => '🌱',
      };

  static PlantCategory fromString(String s) =>
      PlantCategory.values.firstWhere((e) => e.name == s,
          orElse: () => PlantCategory.ovriga);
}

enum SunRequirement {
  fullsol,
  halvskugga,
  skugga;

  String get label => switch (this) {
        SunRequirement.fullsol => 'Full sol',
        SunRequirement.halvskugga => 'Halvskugga',
        SunRequirement.skugga => 'Skugga',
      };

  static SunRequirement fromString(String s) =>
      SunRequirement.values.firstWhere((e) => e.name == s,
          orElse: () => SunRequirement.fullsol);
}

enum WaterNeed {
  sparsam,
  regelbunden,
  riklig;

  String get label => switch (this) {
        WaterNeed.sparsam => 'Sparsam',
        WaterNeed.regelbunden => 'Regelbunden',
        WaterNeed.riklig => 'Riklig',
      };

  static WaterNeed fromString(String s) =>
      WaterNeed.values.firstWhere((e) => e.name == s,
          orElse: () => WaterNeed.regelbunden);
}

enum FertilizerNeed {
  lagt,
  medel,
  hogt;

  String get label => switch (this) {
        FertilizerNeed.lagt => 'Lågt',
        FertilizerNeed.medel => 'Medel',
        FertilizerNeed.hogt => 'Högt',
      };

  static FertilizerNeed fromString(String s) =>
      FertilizerNeed.values.firstWhere((e) => e.name == s,
          orElse: () => FertilizerNeed.medel);
}

class Plant {
  final String id;
  final String namnSv;
  final String namnLat;
  final PlantCategory kategori;
  final String beskrivning;
  final List<int> zoner;
  final MonthRange? forsadatum;
  final MonthRange? direktsadatum;
  final MonthRange? utplanteringsdatum;
  final MonthRange? skordeperiod;
  final int? dagarTillSkord;
  final int? avstandCm;
  final int? djupCm;
  final SunRequirement solkrav;
  final WaterNeed vattning;
  final String? jordPh;
  final FertilizerNeed godselbehov;
  final double? kallighetC;
  final String? instruktioner;
  final String? tips;
  final List<String> skadedjur;
  final String amazonSokord;

  const Plant({
    required this.id,
    required this.namnSv,
    required this.namnLat,
    required this.kategori,
    required this.beskrivning,
    required this.zoner,
    this.forsadatum,
    this.direktsadatum,
    this.utplanteringsdatum,
    this.skordeperiod,
    this.dagarTillSkord,
    this.avstandCm,
    this.djupCm,
    required this.solkrav,
    required this.vattning,
    this.jordPh,
    required this.godselbehov,
    this.kallighetC,
    this.instruktioner,
    this.tips,
    this.skadedjur = const [],
    required this.amazonSokord,
  });

  factory Plant.fromJson(Map<String, dynamic> j) {
    return Plant(
      id: j['id'] as String,
      namnSv: j['namn_sv'] as String,
      namnLat: j['namn_lat'] as String,
      kategori: PlantCategory.fromString(j['kategori'] as String),
      beskrivning: j['beskrivning'] as String? ?? '',
      zoner: List<int>.from(j['zoner'] as List? ?? const []),
      forsadatum: MonthRange.fromJson(j['forsadatum'] as Map<String, dynamic>?),
      direktsadatum:
          MonthRange.fromJson(j['direktsadatum'] as Map<String, dynamic>?),
      utplanteringsdatum: MonthRange.fromJson(
          j['utplanteringsdatum'] as Map<String, dynamic>?),
      skordeperiod:
          MonthRange.fromJson(j['skordeperiod'] as Map<String, dynamic>?),
      dagarTillSkord: j['dagar_till_skord'] as int?,
      avstandCm: j['avstand_cm'] as int?,
      djupCm: j['djup_cm'] as int?,
      solkrav: SunRequirement.fromString(j['solkrav'] as String? ?? 'fullsol'),
      vattning: WaterNeed.fromString(j['vattning'] as String? ?? 'regelbunden'),
      jordPh: j['jord_ph'] as String?,
      godselbehov:
          FertilizerNeed.fromString(j['godselbehov'] as String? ?? 'medel'),
      kallighetC: (j['kallighet_c'] as num?)?.toDouble(),
      instruktioner: j['instruktioner'] as String?,
      tips: j['tips'] as String?,
      skadedjur: List<String>.from(j['skadedjur'] as List? ?? const []),
      amazonSokord: j['amazon_sokord'] as String? ?? j['namn_sv'] as String,
    );
  }

  /// Is this plant frost-sensitive for the given forecast low temperature?
  bool isFrostSensitive(double forecastLowC) {
    final threshold = kallighetC ?? 0;
    return forecastLowC <= threshold;
  }
}
