import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../models/wishlist_plant.dart';
import 'garden_service.dart';

/// Persists the user's "this year I want to grow…" wishlist, scoped to
/// the active garden (multi-trädgård, schema v4+). Wishlist on the
/// balkong differs from wishlist for kolonilotten — same plant might
/// belong to one but not the other.
class SeasonPlannerService extends ChangeNotifier {
  static final SeasonPlannerService _instance =
      SeasonPlannerService._internal();
  factory SeasonPlannerService() => _instance;
  SeasonPlannerService._internal();

  static const _dbName = 'plantera.db';
  static const _table = 'wishlist_plants';

  final GardenService _garden = GardenService();

  Database? _db;
  List<WishlistPlant> _allItems = [];
  bool _loaded = false;
  bool _wired = false;
  final _uuid = const Uuid();

  /// All items across all gardens (administrative — most UI should use
  /// [items] which scopes to the active garden).
  List<WishlistPlant> get allItems => List.unmodifiable(_allItems);

  /// Items in the *currently active* garden.
  List<WishlistPlant> get items {
    final activeId = _garden.activeGardenId;
    if (activeId == null) return List.unmodifiable(_allItems);
    return List.unmodifiable(
        _allItems.where((w) => w.gardenId == activeId).toList());
  }

  bool get loaded => _loaded;
  int get count => items.length;

  List<WishlistPlant> get currentSeason {
    final year = DateTime.now().year;
    return items.where((w) => w.seasonYear == year).toList()
      ..sort((a, b) => a.addedAt.compareTo(b.addedAt));
  }

  bool contains(String plantId, {int? seasonYear}) {
    final year = seasonYear ?? DateTime.now().year;
    return items.any(
        (w) => w.plantId == plantId && w.seasonYear == year);
  }

  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(dbPath);
    // Note: the v4 migration in GardenService.onUpgrade ALTERs the
    // wishlist table to add garden_id. For first-time installs (v4
    // CREATE TABLE on garden_plants), the wishlist table is created
    // here with garden_id from the start.
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS $_table (
        id TEXT PRIMARY KEY,
        plant_id TEXT NOT NULL,
        season_year INTEGER NOT NULL,
        note TEXT,
        added_at INTEGER NOT NULL,
        garden_id TEXT
      )
    ''');
    await _reload();
    if (!_wired) {
      _garden.addListener(notifyListeners);
      _wired = true;
    }
  }

  Future<void> _reload() async {
    if (_db == null) return;
    final rows = await _db!.query(_table, orderBy: 'added_at ASC');
    _allItems = rows.map(WishlistPlant.fromMap).toList();
    _loaded = true;
    notifyListeners();
  }

  Future<WishlistPlant> add({
    required String plantId,
    int? seasonYear,
    String? note,
  }) async {
    final w = WishlistPlant(
      id: _uuid.v4(),
      plantId: plantId,
      seasonYear: seasonYear ?? DateTime.now().year,
      note: note,
      addedAt: DateTime.now(),
      gardenId: _garden.activeGardenId,
    );
    await _db!.insert(_table, w.toMap());
    await _reload();
    return w;
  }

  Future<void> remove(String id) async {
    await _db!.delete(_table, where: 'id = ?', whereArgs: [id]);
    await _reload();
  }

  Future<void> removeByPlantId(String plantId, {int? seasonYear}) async {
    final year = seasonYear ?? DateTime.now().year;
    final activeId = _garden.activeGardenId;
    await _db!.delete(
      _table,
      where: activeId == null
          ? 'plant_id = ? AND season_year = ?'
          : 'plant_id = ? AND season_year = ? AND garden_id = ?',
      whereArgs: activeId == null
          ? [plantId, year]
          : [plantId, year, activeId],
    );
    await _reload();
  }

  Future<void> updateNote(String id, String? note) async {
    await _db!.update(
      _table,
      {'note': note},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _reload();
  }
}
