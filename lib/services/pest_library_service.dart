import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/pest_entry.dart';

/// Loads the static pest/disease library from the bundled JSON. Does no
/// per-user state — it's a reference book the gardener can flip
/// through. Future: optional "tagga som drabbade" log per plant.
class PestLibraryService extends ChangeNotifier {
  static final PestLibraryService _instance = PestLibraryService._internal();
  factory PestLibraryService() => _instance;
  PestLibraryService._internal();

  List<PestEntry> _entries = const [];
  bool _loaded = false;

  List<PestEntry> get entries => List.unmodifiable(_entries);
  bool get loaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString('assets/data/pests.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final list = (data['pests'] as List).cast<Map<String, dynamic>>();
      _entries = list.map(PestEntry.fromJson).toList();
      _loaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('PestLibraryService load failed: $e');
      _entries = const [];
      _loaded = true;
    }
  }

  /// Entries whose [PestEntry.affects] mentions [plantNameLower] (case-
  /// insensitive substring). Used by the plant detail screen to show
  /// "vanliga problem för den här växten".
  List<PestEntry> forPlantName(String plantNameLower) {
    final q = plantNameLower.toLowerCase().trim();
    if (q.isEmpty) return const [];
    return _entries
        .where((p) => p.affects.any((a) => a.toLowerCase().contains(q)))
        .toList();
  }

  /// Free-text search across name + symptoms + affects.
  List<PestEntry> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _entries;
    return _entries.where((p) {
      if (p.name.toLowerCase().contains(q)) return true;
      if (p.symptoms.toLowerCase().contains(q)) return true;
      if (p.affects.any((a) => a.toLowerCase().contains(q))) return true;
      return false;
    }).toList();
  }
}
