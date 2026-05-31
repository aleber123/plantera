import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/garden.dart';
import '../models/garden_plant.dart';

/// Owns the garden_plants + garden_notes tables, the gardens table
/// (multi-trädgård support, schema v4+) and the active-garden state.
///
/// Multi-trädgård design: every GardenPlant has a non-null `garden_id`
/// pointing at one of the rows in `gardens`. The "active garden" is a
/// SharedPreferences key (`active_garden_id`); the public [plants]
/// getter filters automatically. UI that needs all rows across all
/// gardens can use [allPlants].
class GardenService extends ChangeNotifier {
  static final GardenService _instance = GardenService._internal();
  factory GardenService() => _instance;
  GardenService._internal();

  static const _dbName = 'plantera.db';
  static const _tablePlants = 'garden_plants';
  static const _tableNotes = 'garden_notes';
  static const _tableGardens = 'gardens';

  static const _activeGardenKey = 'active_garden_id';
  // Legacy SharedPreferences keys used by ZoneService prior to multi-
  // garden support. Read once during migration so the user's existing
  // zone/lat/lon land on the auto-created default garden.
  static const _legacyZoneKey = 'zone_number';
  static const _legacyCityKey = 'zone_city';
  static const _legacyLatKey = 'zone_lat';
  static const _legacyLonKey = 'zone_lon';

  Database? _db;
  List<GardenPlant> _allPlants = [];
  List<Garden> _gardens = [];
  String? _activeGardenId;
  bool _loaded = false;
  final _uuid = const Uuid();

  /// All plants across all gardens. Use sparingly — most UI should
  /// scope to the active garden via [plants].
  List<GardenPlant> get allPlants => List.unmodifiable(_allPlants);

  /// Plants in the *currently active* garden. This is what 99% of UI
  /// should consume. Returns the legacy "everything" set if there's
  /// no active garden yet (cold-start race).
  List<GardenPlant> get plants {
    final id = _activeGardenId;
    if (id == null) return List.unmodifiable(_allPlants);
    return List.unmodifiable(
        _allPlants.where((g) => g.gardenId == id).toList());
  }

  int get plantCount => plants.length;
  bool get loaded => _loaded;

  List<Garden> get gardens => List.unmodifiable(_gardens);
  String? get activeGardenId => _activeGardenId;
  Garden? get activeGarden {
    final id = _activeGardenId;
    if (id == null) return null;
    for (final g in _gardens) {
      if (g.id == id) return g;
    }
    return null;
  }

  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      dbPath,
      version: 6,
      // SQLite ships with foreign keys *off* by default. Without this,
      // every `ON DELETE CASCADE` we declared silently no-ops and we
      // accumulate zombie notes/harvest entries after plant removal.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tablePlants (
            id TEXT PRIMARY KEY,
            plant_id TEXT NOT NULL,
            custom_name TEXT,
            planted_date INTEGER NOT NULL,
            location TEXT,
            status TEXT NOT NULL,
            sowing_method TEXT NOT NULL DEFAULT 'inomhus',
            quantity INTEGER NOT NULL DEFAULT 1,
            last_watered INTEGER,
            created_at INTEGER NOT NULL,
            hero_photo_path TEXT,
            garden_id TEXT,
            harvest_offset_days INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE $_tableNotes (
            id TEXT PRIMARY KEY,
            garden_plant_id TEXT NOT NULL,
            date INTEGER NOT NULL,
            text TEXT NOT NULL,
            photo_path TEXT,
            FOREIGN KEY (garden_plant_id) REFERENCES $_tablePlants(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE $_tableGardens (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            emoji TEXT NOT NULL DEFAULT '🌱',
            lat REAL,
            lon REAL,
            city TEXT,
            zone INTEGER NOT NULL DEFAULT 3,
            is_default INTEGER NOT NULL DEFAULT 0,
            created_at INTEGER NOT NULL
          )
        ''');
        // Task state tables — only persist what the user has actively
        // touched. The actual task list is computed at read time.
        await db.execute('''
          CREATE TABLE task_completions (
            task_key TEXT PRIMARY KEY,
            completed_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE task_snoozes (
            task_key TEXT PRIMARY KEY,
            snoozed_until INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE $_tablePlants ADD COLUMN hero_photo_path TEXT');
        }
        if (oldVersion < 3) {
          await db.execute(
              "ALTER TABLE $_tablePlants ADD COLUMN sowing_method TEXT NOT NULL DEFAULT 'inomhus'");
          await db.execute(
              "UPDATE $_tablePlants SET status = 'forsoddInne' WHERE status = 'forsadd'");
        }
        if (oldVersion < 4) {
          // Multi-garden migration: add gardens table + foreign-key
          // column on garden_plants. Auto-create a "Min trädgård"
          // using the user's existing zone settings, then assign all
          // existing rows to it so nothing disappears from view.
          await db.execute('''
            CREATE TABLE $_tableGardens (
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              emoji TEXT NOT NULL DEFAULT '🌱',
              lat REAL,
              lon REAL,
              city TEXT,
              zone INTEGER NOT NULL DEFAULT 3,
              is_default INTEGER NOT NULL DEFAULT 0,
              created_at INTEGER NOT NULL
            )
          ''');
          await db.execute(
              'ALTER TABLE $_tablePlants ADD COLUMN garden_id TEXT');
          // Add same column to wishlist_plants if it exists (created
          // by SeasonPlannerService; may be absent on a fresh upgrade
          // that hasn't yet booted the season service).
          final tables = await db.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='wishlist_plants'");
          if (tables.isNotEmpty) {
            await db.execute(
                'ALTER TABLE wishlist_plants ADD COLUMN garden_id TEXT');
          }
          // Pull the legacy zone settings.
          final prefs = await SharedPreferences.getInstance();
          final defaultId = const Uuid().v4();
          await db.insert(_tableGardens, {
            'id': defaultId,
            'name': 'Min trädgård',
            'emoji': '🌿',
            'lat': prefs.getDouble(_legacyLatKey),
            'lon': prefs.getDouble(_legacyLonKey),
            'city': prefs.getString(_legacyCityKey),
            'zone': prefs.getInt(_legacyZoneKey) ?? 3,
            'is_default': 1,
            'created_at': DateTime.now().millisecondsSinceEpoch,
          });
          await db.update(
              _tablePlants, {'garden_id': defaultId},
              where: 'garden_id IS NULL');
          if (tables.isNotEmpty) {
            await db.update(
                'wishlist_plants', {'garden_id': defaultId},
                where: 'garden_id IS NULL');
          }
          // Persist the active garden as the default we just created.
          await prefs.setString(_activeGardenKey, defaultId);
        }
        if (oldVersion < 5) {
          // Task management migration: add the two state tables. The
          // actual tasks themselves are derived at read time so no
          // backfill needed.
          await db.execute('''
            CREATE TABLE task_completions (
              task_key TEXT PRIMARY KEY,
              completed_at INTEGER NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE task_snoozes (
              task_key TEXT PRIMARY KEY,
              snoozed_until INTEGER NOT NULL
            )
          ''');
        }
        if (oldVersion < 6) {
          // Manual harvest-time adjustment: the user can nudge the
          // computed harvest date by ±N days when they see the plant
          // is running ahead/behind schedule. Defaults to 0.
          await db.execute(
              'ALTER TABLE $_tablePlants ADD COLUMN harvest_offset_days INTEGER NOT NULL DEFAULT 0');
        }
      },
    );

    final prefs = await SharedPreferences.getInstance();
    _activeGardenId = prefs.getString(_activeGardenKey);
    await _reload();
    // First-launch fallback: schema was just created (no migration
    // ran), no garden exists, no active id. The OnboardingScreen will
    // create the first garden via `createGarden(...)` once the user
    // picks their zone.
  }

  Future<void> _reload() async {
    if (_db == null) return;
    final results = await Future.wait([
      _db!.query(_tablePlants, orderBy: 'created_at DESC'),
      _db!.query(_tableNotes, orderBy: 'garden_plant_id, date DESC'),
      _db!.query(_tableGardens, orderBy: 'created_at ASC'),
    ]);
    final rows = results[0];
    final noteRows = results[1];
    final gardenRows = results[2];

    final notesByPlant = <String, List<GardenNote>>{};
    for (final n in noteRows) {
      final pid = n['garden_plant_id'] as String;
      (notesByPlant[pid] ??= []).add(GardenNote.fromMap(n));
    }

    _allPlants = rows
        .map((row) => GardenPlant.fromMap(
              row,
              notes: notesByPlant[row['id'] as String] ?? const [],
            ))
        .toList();
    _gardens = gardenRows.map(Garden.fromMap).toList();

    // Self-heal: if active id points at a deleted garden, fall back to
    // the default-flagged row, otherwise the first row, otherwise null.
    if (_activeGardenId != null &&
        !_gardens.any((g) => g.id == _activeGardenId)) {
      _activeGardenId = null;
    }
    if (_activeGardenId == null && _gardens.isNotEmpty) {
      final def = _gardens.firstWhere(
        (g) => g.isDefault,
        orElse: () => _gardens.first,
      );
      _activeGardenId = def.id;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeGardenKey, def.id);
    }

    _loaded = true;
    notifyListeners();
  }

  // ── Garden CRUD ────────────────────────────────────────────────────

  Future<Garden> createGarden({
    required String name,
    String emoji = '🌱',
    double? lat,
    double? lon,
    String? city,
    required int zone,
    bool makeActive = true,
  }) async {
    final isFirst = _gardens.isEmpty;
    final g = Garden(
      id: _uuid.v4(),
      name: name,
      emoji: emoji,
      lat: lat,
      lon: lon,
      city: city,
      zone: zone,
      isDefault: isFirst,
      createdAt: DateTime.now(),
    );
    await _db!.insert(_tableGardens, g.toMap());
    if (makeActive) {
      _activeGardenId = g.id;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeGardenKey, g.id);
    }
    await _reload();
    return g;
  }

  Future<void> updateGarden(Garden g) async {
    await _db!
        .update(_tableGardens, g.toMap(), where: 'id = ?', whereArgs: [g.id]);
    await _reload();
  }

  Future<void> deleteGarden(String id) async {
    if (_gardens.length <= 1) {
      throw Exception('Du måste ha minst en trädgård.');
    }
    // Move plants to default garden so we don't orphan rows. Wishlist
    // rows need the same fix-up — they're keyed on garden_id and would
    // otherwise become invisible after the parent garden disappears.
    final fallback = _gardens.firstWhere(
      (g) => g.id != id && g.isDefault,
      orElse: () => _gardens.firstWhere((g) => g.id != id),
    );
    // Wrap the multi-step migration in a transaction so a partial
    // failure (disk full mid-update, OS kill) doesn't leave the user
    // with plants/wishlist rows pointing at the deleted garden id —
    // those would silently disappear from every UI scope.
    await _db!.transaction((txn) async {
      await txn.update(_tablePlants, {'garden_id': fallback.id},
          where: 'garden_id = ?', whereArgs: [id]);
      final tables = await txn.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='wishlist_plants'");
      if (tables.isNotEmpty) {
        await txn.update('wishlist_plants', {'garden_id': fallback.id},
            where: 'garden_id = ?', whereArgs: [id]);
      }
      await txn.delete(_tableGardens, where: 'id = ?', whereArgs: [id]);
    });
    if (_activeGardenId == id) {
      // Persist active-garden pref BEFORE mutating in-memory state, so
      // a crash between the two doesn't leave the app pointing at a
      // deleted garden id on next launch.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeGardenKey, fallback.id);
      _activeGardenId = fallback.id;
    }
    await _reload();
  }

  Future<void> setActiveGarden(String id) async {
    if (_activeGardenId == id) return;
    _activeGardenId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeGardenKey, id);
    notifyListeners();
  }

  // ── GardenPlant CRUD ───────────────────────────────────────────────

  Future<GardenPlant> add({
    required String plantId,
    String? customName,
    DateTime? plantedDate,
    String? location,
    PlantStatus status = PlantStatus.planerad,
    SowingMethod sowingMethod = SowingMethod.inomhus,
    int quantity = 1,
  }) async {
    final activeId = _activeGardenId;
    if (activeId == null) {
      throw StateError(
          'Ingen aktiv trädgård. Skapa först via createGarden().');
    }
    final gp = GardenPlant(
      id: _uuid.v4(),
      plantId: plantId,
      customName: customName,
      plantedDate: plantedDate ?? DateTime.now(),
      location: location,
      status: status,
      sowingMethod: sowingMethod,
      quantity: quantity,
      createdAt: DateTime.now(),
      gardenId: activeId,
    );
    await _db!.insert(_tablePlants, gp.toMap());
    await _reload();
    return gp;
  }

  Future<void> update(GardenPlant gp) async {
    await _db!.update(_tablePlants, gp.toMap(),
        where: 'id = ?', whereArgs: [gp.id]);
    await _reload();
  }

  Future<void> remove(String id) async {
    final gp = _allPlants.where((g) => g.id == id).firstOrNull;
    if (gp != null) {
      for (final note in gp.notes) {
        final p = note.photoPath;
        if (p == null) continue;
        try {
          final f = File(p);
          if (f.existsSync()) await f.delete();
        } catch (_) {/* best effort */}
      }
      final hero = gp.heroPhotoPath;
      if (hero != null) {
        try {
          final f = File(hero);
          if (f.existsSync()) await f.delete();
        } catch (_) {/* best effort */}
      }
    }
    // Explicit cleanup of dependent rows. We do this even though the
    // foreign-key cascade *should* handle notes — older databases were
    // created with FKs off and may have orphan rows that the cascade
    // can't reach. harvest_entries has no in-place FK on legacy DBs,
    // so always explicit-delete. task_completions/task_snoozes are
    // string-keyed and grow forever otherwise; clean by suffix.
    await _db!
        .delete(_tableNotes, where: 'garden_plant_id = ?', whereArgs: [id]);
    await _db!
        .delete('harvest_entries', where: 'garden_plant_id = ?', whereArgs: [id]);
    await _db!.delete(
      'task_completions',
      where: "task_key LIKE ? OR task_key LIKE ?",
      whereArgs: ['%-$id-%', '%-$id'],
    );
    await _db!.delete(
      'task_snoozes',
      where: "task_key LIKE ? OR task_key LIKE ?",
      whereArgs: ['%-$id-%', '%-$id'],
    );
    await _db!.delete(_tablePlants, where: 'id = ?', whereArgs: [id]);
    await _reload();
  }

  Future<void> markWatered(String id) async {
    final gp = _allPlants.where((g) => g.id == id).firstOrNull;
    if (gp == null) return;
    await update(gp.copyWith(lastWatered: DateTime.now()));
  }

  Future<void> setHeroPhoto(String id, String? photoPath) async {
    final gp = _allPlants.where((g) => g.id == id).firstOrNull;
    if (gp == null) return;
    final updated = photoPath == null
        ? gp.copyWith(clearHeroPhoto: true)
        : gp.copyWith(heroPhotoPath: photoPath);
    await update(updated);
  }

  Future<void> addNote(String gardenPlantId, String text,
      {String? photoPath}) async {
    final note = GardenNote(
      id: _uuid.v4(),
      date: DateTime.now(),
      text: text,
      photoPath: photoPath,
    );
    await _db!.insert(_tableNotes, {
      ...note.toMap(),
      'garden_plant_id': gardenPlantId,
    });
    await _reload();
  }

  Future<void> deleteNote(String noteId) async {
    await _db!.delete(_tableNotes, where: 'id = ?', whereArgs: [noteId]);
    await _reload();
  }
}
