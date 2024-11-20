

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../model/form_outlet_response.dart';
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


  /// CRUD FORM OUTLET
  Future<bool> isOutletFormsEmpty() async {
    final db = await database;
    final result = await db.query('outlet_forms');
    return result.isEmpty;
  }

  // Insert single outlet form
  Future<void> insertOutletForm(OutletForm form) async {
    final db = await database;
    await db.insert(
      'outlet_forms',
      {
        'id': form.id,
        'question': form.question,
        'type': form.type,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'deleted_at': null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert batch of outlet forms
  Future<void> insertOutletFormBatch(List<Map<String, dynamic>> forms) async {
    final db = await database;
    final batch = db.batch();

    for (var form in forms) {
      batch.insert(
        'outlet_forms',
        {
          'id': form['id'].toString(),
          'question': form['question'].toString(),
          'type': form['type'].toString(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'deleted_at': null,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<FormOutletResponse>> getAllForms() async {
    final db = await database;
    final result = await db.query('outlet_forms');

    return result.map((map) => FormOutletResponse.fromJson(map)).toList();
  }

  // Get all outlet forms
  Future<List<OutletForm>> getAllOutletForms() async {
    final db = await database;
    final results = await db.query('outlet_forms');

    return results.map((map) => OutletForm(
      id: map['id'] as String,
      question: map['question'] as String,
      type: map['type'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'] as String)
          : null,
    )).toList();
  }

  ///CRUD OUTLET WITH ANSWER FORM
  Future<void> insertOutletWithAnswers({
    required Map<String, dynamic> data,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      try {
        // 1. Insert outlet
        final outlet = {
          'id': data['id'],
          'salesName': data['salesName'],
          'outletName': data['outletName'],
          'category': data['category'],
          'longitude': data['longitude'],
          'latitude': data['latitude'],
          'address': data['address'],
          'status': data['status'],
          'created_at': data['created_at'],
          'updated_at': data['updated_at'],
          'deleted_at': null,
        };

        await txn.insert('outlets', outlet);

        // 2. Insert form answers
        final formAnswers = <Map<String, dynamic>>[];

        // Get all keys that start with 'form_id_'
        final formKeys = data.keys.where((key) => key.startsWith('form_id_')).toList();

        for (var key in formKeys) {
          // Extract form ID from key (e.g., 'form_id_1' -> '1')
          final formId = key.split('_').last;

          formAnswers.add({
            'id': const Uuid().v4(), // Generate unique ID for answer
            'outlet_id': data['id'],
            'outlet_form_id': formId,
            'answer': data[key].toString(),
            'created_at': data['created_at'],
            'updated_at': data['updated_at'],
            'deleted_at': null,
          });
        }

        // Insert all answers
        for (var answer in formAnswers) {
          await txn.insert('outlet_form_answers', answer);
        }

      } catch (e) {
        print('Error in transaction: $e');
        rethrow;
      }
    });
  }

  // Method get Outlet list
  Future<List<Map<String, dynamic>>> getAllOutletWithAnswers() async {
    final db = await database;
    final List<Map<String, dynamic>> result = [];

    // Get all outlets
    final outlets = await db.query('outlets');

    for (var outlet in outlets) {
      // Get all answers for this outlet
      final answers = await db.rawQuery('''
       SELECT 
         a.outlet_form_id,
         a.answer
       FROM outlet_form_answers a
       WHERE a.outlet_id = ?
     ''', [outlet['id']]);

      // Create new map starting with outlet data
      final Map<String, dynamic> outletWithAnswers = {...outlet};

      // Add answers with prefix
      for (var answer in answers) {
        outletWithAnswers['answer_form_id_${answer['outlet_form_id']}'] =
        answer['answer'];
      }

      result.add(outletWithAnswers);
    }

    return result;
  }

  // CRUD Operations
  // Future<int> insertOutlet(Outlet outlet) async {
  //   final db = await database;
  //   return await db.insert('outlets', outlet.toJson());
  // }
  //
  // Future<void> insertOutletBatch(List<Outlet> outlets) async {
  //   final db = await database;
  //   final batch = db.batch();
  //
  //   for (var outlet in outlets) {
  //     batch.insert('outlets', outlet.toJson());
  //   }
  //
  //   await batch.commit(noResult: true);
  // }
  //
  // Future<Outlet?> getOutlet(String id) async {
  //   final db = await database;
  //   final maps = await db.query(
  //     'outlets',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //
  //   if (maps.isNotEmpty) {
  //     return Outlet.fromJson(maps.first);
  //   }
  //   return null;
  // }
  //
  // Future<List<Outlet>> getAllOutlets() async {
  //   final db = await database;
  //   final result = await db.query('outlets');
  //   return result.map((json) => Outlet.fromJson(json)).toList();
  // }
  //
  // Future<List<Map<String, dynamic>>> getOutletWithAnswers(String outletId) async {
  //   final db = await database;
  //   return await db.rawQuery('''
  //     SELECT o.*, ofa.answer, of.question, of.type
  //     FROM outlets o
  //     LEFT JOIN outlet_form_answers ofa ON o.id = ofa.outlet_id
  //     LEFT JOIN outlet_forms of ON ofa.outlet_form_id = of.id
  //     WHERE o.id = ?
  //   ''', [outletId]);
  // }
  //
  // Future<int> updateOutlet(Outlet outlet) async {
  //   final db = await database;
  //   return await db.update(
  //     'outlets',
  //     outlet.toJson(),
  //     where: 'id = ?',
  //     whereArgs: [outlet.id],
  //   );
  // }
  //
  // Future<int> deleteOutlet(String id) async {
  //   final db = await database;
  //   return await db.delete(
  //     'outlets',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }
  //
  // ///CRUD OUTLET FORM
  // Future<List<OutletForm>> getAllOutletForms() async {
  //   final db = await database;
  //   final result = await db.query('outlet_forms');
  //   return result.map((json) => OutletForm.fromJson(json)).toList();
  // }
  //
  // Future<int> insertOutletForm(OutletForm form) async {
  //   final db = await database;
  //   return await db.insert('outlet_forms', form.toJson());
  // }
  //
  // // Batch Insert OutletForms
  //
  // Future<void> insertOutletFormBatch(List<OutletForm> forms) async {
  //   final db = await database;
  //
  //   await db.transaction((txn) async {
  //     for (var form in forms) {
  //       try {
  //         // Check if form already exists
  //         final existing = await txn.query(
  //           'outlet_forms',
  //           where: 'question = ?',
  //           whereArgs: [form.question],
  //         );
  //
  //         if (existing.isEmpty) {
  //           await txn.insert(
  //             'outlet_forms',
  //             form.toJson(),
  //             conflictAlgorithm: ConflictAlgorithm.ignore, // Skip if exists
  //           );
  //         } else {
  //           // Optionally update existing record
  //           await txn.update(
  //             'outlet_forms',
  //             form.toJson(),
  //             where: 'id = ?',
  //             whereArgs: [existing.first['id']],
  //           );
  //         }
  //       } catch (e) {
  //         print('Error inserting form: ${form.question} - $e');
  //       }
  //     }
  //   });
  // }
  //
  // // Alternative approach using UPSERT
  // Future<void> upsertOutletFormBatch(List<OutletForm> forms) async {
  //   final db = await database;
  //
  //   await db.transaction((txn) async {
  //     for (var form in forms) {
  //       await txn.insert(
  //         'outlet_forms',
  //         form.toJson(),
  //         conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
  //       );
  //     }
  //   });
  // }
  //
  // // Clear existing data before insert
  // Future<void> clearAndInsertOutletFormBatch(List<OutletForm> forms) async {
  //   final db = await database;
  //
  //   await db.transaction((txn) async {
  //     // Clear existing data
  //     await txn.delete('outlet_forms');
  //
  //     // Insert new data
  //     for (var form in forms) {
  //       await txn.insert('outlet_forms', form.toJson());
  //     }
  //   });
  // }
}