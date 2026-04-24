import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../models/garden_plant.dart';

class GardenService extends ChangeNotifier {
  static final GardenService _instance = GardenService._internal();
  factory GardenService() => _instance;
  GardenService._internal();

  static const _dbName = 'plantera.db';
  static const _tablePlants = 'garden_plants';
  static const _tableNotes = 'garden_notes';

  Database? _db;
  List<GardenPlant> _plants = [];
  bool _loaded = false;
  final _uuid = const Uuid();

  List<GardenPlant> get plants => List.unmodifiable(_plants);
  int get plantCount => _plants.length;
  bool get loaded => _loaded;

  Future<void> initialize() async {
    if (_db != null) return;
    final dbPath = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tablePlants (
            id TEXT PRIMARY KEY,
            plant_id TEXT NOT NULL,
            custom_name TEXT,
            planted_date INTEGER NOT NULL,
            location TEXT,
            status TEXT NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            last_watered INTEGER,
            created_at INTEGER NOT NULL
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
      },
    );
    await _reload();
  }

  Future<void> _reload() async {
    if (_db == null) return;
    final rows = await _db!
        .query(_tablePlants, orderBy: 'created_at DESC');
    final list = <GardenPlant>[];
    for (final row in rows) {
      final noteRows = await _db!.query(
        _tableNotes,
        where: 'garden_plant_id = ?',
        whereArgs: [row['id']],
        orderBy: 'date DESC',
      );
      final notes = noteRows.map((n) => GardenNote.fromMap(n)).toList();
      list.add(GardenPlant.fromMap(row, notes: notes));
    }
    _plants = list;
    _loaded = true;
    notifyListeners();
  }

  Future<GardenPlant> add({
    required String plantId,
    String? customName,
    DateTime? plantedDate,
    String? location,
    PlantStatus status = PlantStatus.forsadd,
    int quantity = 1,
  }) async {
    final gp = GardenPlant(
      id: _uuid.v4(),
      plantId: plantId,
      customName: customName,
      plantedDate: plantedDate ?? DateTime.now(),
      location: location,
      status: status,
      quantity: quantity,
      createdAt: DateTime.now(),
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
    await _db!.delete(_tablePlants, where: 'id = ?', whereArgs: [id]);
    await _reload();
  }

  Future<void> markWatered(String id) async {
    final gp = _plants.firstWhere((g) => g.id == id);
    await update(gp.copyWith(lastWatered: DateTime.now()));
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
