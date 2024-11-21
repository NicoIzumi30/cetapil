import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/get_city_response.dart';

class CitiesDatabaseHelper {
  static final CitiesDatabaseHelper instance = CitiesDatabaseHelper._init();
  static Database? _database;

  CitiesDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cities_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cities (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
  }

  // Insert cities from API response
  Future<void> insertCities(List<Data> cities) async {
    final db = await database;

    await db.transaction((txn) async {
      for (var city in cities) {
        await txn.insert(
          'cities',
          {
            'id': city.id,
            'name': city.name,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // Get all cities
  Future<List<Data>> getAllCities() async {
    final db = await database;
    final results = await db.query('cities', orderBy: 'name ASC');

    return results
        .map((map) => Data(
              id: map['id'] as String,
              name: map['name'] as String,
            ))
        .toList();
  }

  // Search cities by name
  Future<List<Data>> searchCities(String query) async {
    final db = await database;
    final results = await db.query(
      'cities',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );

    return results
        .map((map) => Data(
              id: map['id'] as String,
              name: map['name'] as String,
            ))
        .toList();
  }

  // Check if cities table is empty
  Future<bool> isCitiesEmpty() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM cities');
    return (result.first['count'] as int) == 0;
  }

  // Clear all cities
  Future<void> clearCities() async {
    final db = await database;
    await db.delete('cities');
  }
}
