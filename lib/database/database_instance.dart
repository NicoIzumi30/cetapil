

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/outlet_example.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cetaphil.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE outlets (
        id TEXT PRIMARY KEY,
        salesName TEXT NOT NULL,
        outletName TEXT NOT NULL,
        category TEXT NOT NULL,
        longitude TEXT NOT NULL,
        latitude TEXT NOT NULL,
        address TEXT NOT NULL,
        status TEXT NOT NULL CHECK(status IN ('APPROVED','PENDING','REJECTED')),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE outlet_forms (
        id TEXT PRIMARY KEY,
        question TEXT NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('bool','text')),
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      ) 
    ''');

    await db.execute('''
      CREATE TABLE outlet_form_answers (
        id TEXT PRIMARY KEY,
        outlet_id TEXT NOT NULL,
        outlet_form_id TEXT NOT NULL,
        answer TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY (outlet_id) REFERENCES outlets (id),
        FOREIGN KEY (outlet_form_id) REFERENCES outlet_forms (id)
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertOutlet(Outlet outlet) async {
    final db = await database;
    return await db.insert('outlets', outlet.toJson());
  }

  Future<void> insertOutletBatch(List<Outlet> outlets) async {
    final db = await database;
    final batch = db.batch();

    for (var outlet in outlets) {
      batch.insert('outlets', outlet.toJson());
    }

    await batch.commit(noResult: true);
  }

  Future<Outlet?> getOutlet(String id) async {
    final db = await database;
    final maps = await db.query(
      'outlets',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Outlet.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Outlet>> getAllOutlets() async {
    final db = await database;
    final result = await db.query('outlets');
    return result.map((json) => Outlet.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getOutletWithAnswers(String outletId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT o.*, ofa.answer, of.question, of.type
      FROM outlets o
      LEFT JOIN outlet_form_answers ofa ON o.id = ofa.outlet_id
      LEFT JOIN outlet_forms of ON ofa.outlet_form_id = of.id
      WHERE o.id = ?
    ''', [outletId]);
  }

  Future<int> updateOutlet(Outlet outlet) async {
    final db = await database;
    return await db.update(
      'outlets',
      outlet.toJson(),
      where: 'id = ?',
      whereArgs: [outlet.id],
    );
  }

  Future<int> deleteOutlet(String id) async {
    final db = await database;
    return await db.delete(
      'outlets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///CRUD OUTLET FORM
  Future<List<OutletForm>> getAllOutletForms() async {
    final db = await database;
    final result = await db.query('outlet_forms');
    return result.map((json) => OutletForm.fromJson(json)).toList();
  }

  Future<int> insertOutletForm(OutletForm form) async {
    final db = await database;
    return await db.insert('outlet_forms', form.toJson());
  }

  // Batch Insert OutletForms

  Future<void> insertOutletFormBatch(List<OutletForm> forms) async {
    final db = await database;

    await db.transaction((txn) async {
      for (var form in forms) {
        try {
          // Check if form already exists
          final existing = await txn.query(
            'outlet_forms',
            where: 'question = ?',
            whereArgs: [form.question],
          );

          if (existing.isEmpty) {
            await txn.insert(
              'outlet_forms',
              form.toJson(),
              conflictAlgorithm: ConflictAlgorithm.ignore, // Skip if exists
            );
          } else {
            // Optionally update existing record
            await txn.update(
              'outlet_forms',
              form.toJson(),
              where: 'id = ?',
              whereArgs: [existing.first['id']],
            );
          }
        } catch (e) {
          print('Error inserting form: ${form.question} - $e');
        }
      }
    });
  }

  // Alternative approach using UPSERT
  Future<void> upsertOutletFormBatch(List<OutletForm> forms) async {
    final db = await database;

    await db.transaction((txn) async {
      for (var form in forms) {
        await txn.insert(
          'outlet_forms',
          form.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
        );
      }
    });
  }

  // Clear existing data before insert
  Future<void> clearAndInsertOutletFormBatch(List<OutletForm> forms) async {
    final db = await database;

    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete('outlet_forms');

      // Insert new data
      for (var form in forms) {
        await txn.insert('outlet_forms', form.toJson());
      }
    });
  }
}