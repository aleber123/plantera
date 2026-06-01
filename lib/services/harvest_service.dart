import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/harvest_entry.dart';

class HarvestService extends ChangeNotifier {
  static final HarvestService _instance = HarvestService._internal();
  factory HarvestService() => _instance;
  HarvestService._internal();

  // Same db file as GardenService — sqflite happily shares connections
  // by path. We use CREATE TABLE IF NOT EXISTS so we don't have to
  // coordinate version migrations across services.
  static const _dbName = 'plantera.db';
  static const _table = 'harvest_entries';

  Database? _db;
  List<HarvestEntry> _entries = [];
  bool _loaded = false;
  final _uuid = const Uuid();

  List<HarvestEntry> get entries => List.unmodifiable(_entries);
  bool get loaded => _loaded;

  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      dbPath,
      // PRAGMA foreign_keys is per-connection. GardenService sets it
      // too; we need it here so DELETE on garden_plants cascades into
      // harvest_entries.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS $_table (
        id TEXT PRIMARY KEY,
        garden_plant_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        amount REAL NOT NULL,
        unit TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (garden_plant_id) REFERENCES garden_plants(id) ON DELETE CASCADE
      )
    ''');
    // Backfill: older DBs created this table without the FK. SQLite
    // doesn't let us ADD FOREIGN KEY in place, so we just live with
    // legacy rows getting cleaned via explicit cascade in
    // GardenService.remove instead.
    await _reload();
  }

  Future<void> _reload() async {
    if (_db == null) return;
    final rows = await _db!.query(_table, orderBy: 'date DESC');
    _entries = rows.map(HarvestEntry.fromMap).toList();
    _loaded = true;
    notifyListeners();
  }

  /// Re-reads the cache from disk. GardenService removes a plant by
  /// cascading the DELETE into harvest_entries; this service's in-memory
  /// list doesn't know about that, so the garden change-listener calls
  /// this to drop the now-orphaned rows.
  Future<void> reloadFromDb() => _reload();

  Future<HarvestEntry> add({
    required String gardenPlantId,
    required DateTime date,
    required double amount,
    required HarvestUnit unit,
    String? notes,
  }) async {
    final entry = HarvestEntry(
      id: _uuid.v4(),
      gardenPlantId: gardenPlantId,
      date: date,
      amount: amount,
      unit: unit,
      notes: notes,
    );
    await _db!.insert(_table, entry.toMap());
    await _reload();
    return entry;
  }

  Future<void> remove(String id) async {
    await _db!.delete(_table, where: 'id = ?', whereArgs: [id]);
    await _reload();
  }

  /// Total per unit for a given garden plant.
  Map<HarvestUnit, double> totalsForPlant(String gardenPlantId) {
    final out = <HarvestUnit, double>{};
    for (final e in _entries.where((e) => e.gardenPlantId == gardenPlantId)) {
      out[e.unit] = (out[e.unit] ?? 0) + e.amount;
    }
    return out;
  }

  List<HarvestEntry> forPlant(String gardenPlantId) =>
      _entries.where((e) => e.gardenPlantId == gardenPlantId).toList();

  /// Returns total per unit, grouped by year.
  Map<int, Map<HarvestUnit, double>> totalsByYear() {
    final out = <int, Map<HarvestUnit, double>>{};
    for (final e in _entries) {
      final y = e.date.year;
      final byUnit = out.putIfAbsent(y, () => <HarvestUnit, double>{});
      byUnit[e.unit] = (byUnit[e.unit] ?? 0) + e.amount;
    }
    return out;
  }

  /// Returns total per unit per garden plant for a given year.
  Map<String, Map<HarvestUnit, double>> totalsByPlantForYear(int year) {
    final out = <String, Map<HarvestUnit, double>>{};
    for (final e in _entries.where((e) => e.date.year == year)) {
      final byUnit = out.putIfAbsent(e.gardenPlantId, () => {});
      byUnit[e.unit] = (byUnit[e.unit] ?? 0) + e.amount;
    }
    return out;
  }
}
