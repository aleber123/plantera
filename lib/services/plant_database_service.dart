import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/plant.dart';
import '../utils/climate_zones.dart';

class PlantDatabaseService extends ChangeNotifier {
  static final PlantDatabaseService _instance =
      PlantDatabaseService._internal();
  factory PlantDatabaseService() => _instance;
  PlantDatabaseService._internal();

  List<Plant> _plants = [];
  bool _loaded = false;

  List<Plant> get plants => List.unmodifiable(_plants);
  bool get loaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString('assets/data/plants.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final list = (data['plants'] as List)
          .map((e) => Plant.fromJson(e as Map<String, dynamic>))
          .toList();
      _plants = list;
      _loaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load plants.json: $e');
      _plants = [];
      _loaded = true;
      notifyListeners();
    }
  }

  Plant? byId(String id) => _plants.where((p) => p.id == id).firstOrNull;

  List<Plant> byCategory(PlantCategory c) =>
      _plants.where((p) => p.kategori == c).toList();

  List<Plant> searchByName(String query) {
    if (query.isEmpty) return _plants;
    final q = query.toLowerCase();
    return _plants
        .where((p) =>
            p.namnSv.toLowerCase().contains(q) ||
            p.namnLat.toLowerCase().contains(q))
        .toList();
  }

  /// Plants that can be pre-sown (förså) in the given month for the
  /// given zone. The optional [hemi] flips the calendar for southern-
  /// hemisphere users — a Sydney gardener's January maps to a Swedish
  /// gardener's July for the purposes of looking up plant timing.
  List<Plant> forsaIMonth(int month, int zone,
      {Hemisphere hemi = Hemisphere.north}) {
    final m = hemi.shiftMonth(month);
    return _plants
        .where((p) =>
            p.zoner.contains(zone) &&
            p.forsadatum != null &&
            p.forsadatum!.includes(m))
        .toList();
  }

  /// Plants that can be direct-sown outdoors in the given month/zone.
  List<Plant> direktsaIMonth(int month, int zone,
      {Hemisphere hemi = Hemisphere.north}) {
    final m = hemi.shiftMonth(month);
    return _plants
        .where((p) =>
            p.zoner.contains(zone) &&
            p.direktsadatum != null &&
            p.direktsadatum!.includes(m))
        .toList();
  }

  /// Plants that should be transplanted out in the given month/zone.
  List<Plant> utplanteringIMonth(int month, int zone,
      {Hemisphere hemi = Hemisphere.north}) {
    final m = hemi.shiftMonth(month);
    return _plants
        .where((p) =>
            p.zoner.contains(zone) &&
            p.utplanteringsdatum != null &&
            p.utplanteringsdatum!.includes(m))
        .toList();
  }

  /// Plants harvestable in the given month/zone.
  List<Plant> skordIMonth(int month, int zone,
      {Hemisphere hemi = Hemisphere.north}) {
    final m = hemi.shiftMonth(month);
    return _plants
        .where((p) =>
            p.zoner.contains(zone) &&
            p.skordeperiod != null &&
            p.skordeperiod!.includes(m))
        .toList();
  }
}
