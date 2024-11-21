  import 'package:cetapil_mobile/model/outlet.dart';
  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';
  import 'package:uuid/uuid.dart';

  class DatabaseHelper {
    static final DatabaseHelper instance = DatabaseHelper._init();
    static Database? _database;

    DatabaseHelper._init();

    Future<Database> get database async {
      if (_database != null) return _database!;
      _database = await _initDB('outlet_database.db');
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
        CREATE TABLE outlets (
          id TEXT PRIMARY KEY,
          user_id TEXT,
          user_name TEXT,
          name TEXT NOT NULL,
          category TEXT,
          visit_day TEXT,
          longitude TEXT,
          latitude TEXT,
          city_id TEXT,
          city_name TEXT,
          address TEXT,
          status TEXT CHECK(status IN ('APPROVED', 'PENDING', 'REJECTED')),
          week_type TEXT,
          cycle TEXT,
          sales_activity TEXT,
          data_source TEXT NOT NULL CHECK(data_source IN ('API', 'DRAFT')),
          is_synced INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          deleted_at TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE outlet_images (
          id TEXT PRIMARY KEY,
          outlet_id TEXT NOT NULL,
          position INTEGER,
          filename TEXT,
          image TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY (outlet_id) REFERENCES outlets (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE outlet_forms (
          id TEXT PRIMARY KEY,
          type TEXT NOT NULL,
          question TEXT NOT NULL,
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

    // Insert or update outlet from API
    Future<void> upsertOutletFromApi(Outlet outlet) async {
      final db = await database;

      await db.transaction((txn) async {
        // Insert/Update main outlet data
        await txn.insert(
          'outlets',
          {
            'id': outlet.id,
            'user_id': outlet.user?.id,
            'user_name': outlet.user?.name,
            'name': outlet.name,
            'category': outlet.category,
            'visit_day': outlet.visitDay,
            'longitude': outlet.longitude,
            'latitude': outlet.latitude,
            'city_id': outlet.city?.id,
            'city_name': outlet.city?.name,
            'address': outlet.address,
            'status': outlet.status,
            'week_type': outlet.weekType?.toString(),
            'cycle': outlet.cycle,
            'sales_activity': outlet.salesActivity?.toString(),
            'data_source': 'API',
            'is_synced': 1,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Handle images
        if (outlet.images != null) {
          // Delete existing images
          await txn.delete(
            'outlet_images',
            where: 'outlet_id = ?',
            whereArgs: [outlet.id],
          );

          // Insert new images
          for (var image in outlet.images!) {
            await txn.insert(
              'outlet_images',
              {
                'id': image.id ?? const Uuid().v4(),
                'outlet_id': outlet.id,
                'position': image.position,
                'filename': image.filename,
                'image': image.image,
                'created_at': DateTime.now().toIso8601String(),
              },
            );
          }
        }

        // Handle forms and answers
        if (outlet.forms != null) {
          for (var form in outlet.forms!) {
            if (form.outletForm != null) {
              // Insert/Update form
              await txn.insert(
                'outlet_forms',
                {
                  'id': form.outletForm!.id,
                  'type': form.outletForm!.type,
                  'question': form.outletForm!.question,
                  'created_at': DateTime.now().toIso8601String(),
                  'updated_at': DateTime.now().toIso8601String(),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );

              // Insert answer
              await txn.insert(
                'outlet_form_answers',
                {
                  'id': form.id ?? const Uuid().v4(),
                  'outlet_id': outlet.id,
                  'outlet_form_id': form.outletForm!.id,
                  'answer': form.answer,
                  'created_at': DateTime.now().toIso8601String(),
                  'updated_at': DateTime.now().toIso8601String(),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }
      });
    }

    // Insert draft outlet
    Future<String> insertDraftOutlet(Outlet outlet) async {
      final db = await database;
      final outletId = const Uuid().v4();

      await db.transaction((txn) async {
        await txn.insert(
          'outlets',
          {
            'id': outletId,
            'name': outlet.name,
            'category': outlet.category,
            'longitude': outlet.longitude,
            'latitude': outlet.latitude,
            'address': outlet.address,
            'status': 'PENDING',
            'data_source': 'DRAFT',
            'is_synced': 0,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
        );

        // Handle images
        if (outlet.images != null) {
          for (var image in outlet.images!) {
            await txn.insert(
              'outlet_images',
              {
                'id': const Uuid().v4(),
                'outlet_id': outletId,
                'position': image.position,
                'filename': image.filename,
                'image': image.image,
                'created_at': DateTime.now().toIso8601String(),
              },
            );
          }
        }

        // Handle forms and answers
        if (outlet.forms != null) {
          for (var form in outlet.forms!) {
            await txn.insert(
              'outlet_form_answers',
              {
                'id': const Uuid().v4(),
                'outlet_id': outletId,
                'outlet_form_id': form.outletForm!.id,
                'answer': form.answer,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              },
            );
          }
        }
      });

      return outletId;
    }

    // Get all outlets with their details
    Future<List<Outlet>> getAllOutlets({String? dataSource}) async {
      final db = await database;

      final List<Map<String, dynamic>> outletMaps = await db.query(
        'outlets',
        where: dataSource != null ? 'data_source = ?' : null,
        whereArgs: dataSource != null ? [dataSource] : null,
      );

      return Future.wait(outletMaps.map((outletMap) async {
        // Get images
        final images = await db.query(
          'outlet_images',
          where: 'outlet_id = ?',
          whereArgs: [outletMap['id']],
        );

        // Get forms and answers
        final formAnswers = await db.rawQuery('''
          SELECT f.*, fa.id as answer_id, fa.answer
          FROM outlet_forms f
          INNER JOIN outlet_form_answers fa ON f.id = fa.outlet_form_id
          WHERE fa.outlet_id = ?
        ''', [outletMap['id']]);

        // Transform data back to Outlet model
        return Outlet(
          id: outletMap['id'],
          user: outletMap['user_id'] != null
              ? User(id: outletMap['user_id'], name: outletMap['user_name'])
              : null,
          name: outletMap['name'],
          category: outletMap['category'],
          visitDay: outletMap['visit_day'],
          longitude: outletMap['longitude'],
          latitude: outletMap['latitude'],
          city: outletMap['city_id'] != null
              ? City(id: outletMap['city_id'], name: outletMap['city_name'])
              : null,
          address: outletMap['address'],
          status: outletMap['status'],
          weekType: outletMap['week_type'],
          cycle: outletMap['cycle'],
          salesActivity: outletMap['sales_activity'],
          images: images.map((img) => Images.fromJson(img)).toList(),
          forms: formAnswers.map((form) => Forms.fromJson(form)).toList(),
        );
      }));
    }

    // Get unsynchronized draft outlets
    Future<List<Outlet>> getUnsyncedDraftOutlets() async {
      return getAllOutlets(dataSource: 'DRAFT');
    }

    // Mark outlet as synced
    Future<void> markOutletAsSynced(String outletId) async {
      final db = await database;
      await db.update(
        'outlets',
        {
          'is_synced': 1,
          'data_source': 'API',
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [outletId],
      );
    }

    // Delete outlet
    Future<void> deleteOutlet(String outletId) async {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete(
          'outlet_form_answers',
          where: 'outlet_id = ?',
          whereArgs: [outletId],
        );

        await txn.delete(
          'outlet_images',
          where: 'outlet_id = ?',
          whereArgs: [outletId],
        );

        await txn.delete(
          'outlets',
          where: 'id = ?',
          whereArgs: [outletId],
        );
      });
    }

    // Check if form table is empty
    Future<bool> isOutletFormsEmpty() async {
      final db = await database;
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count FROM outlet_forms 
        WHERE deleted_at IS NULL
      ''');

      return (result.first['count'] as int) == 0;
    }

    // Insert multiple outlet forms
    Future<void> insertOutletFormBatch(List<Map<String, dynamic>> forms) async {
      final db = await database;
      await db.transaction((txn) async {
        try {
          for (var form in forms) {
            await txn.insert(
              'outlet_forms',
              {
                'id': form['id'] ?? const Uuid().v4(),
                'type': form['type'],
                'question': form['question'],
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
                'deleted_at': null,
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        } catch (e) {
          print('Error in insertOutletFormBatch: $e');
          rethrow;
        }
      });
    }

    // Get all forms
    Future<List<Map<String, dynamic>>> getAllForms() async {
      final db = await database;
      return await db.query(
        'outlet_forms',
        where: 'deleted_at IS NULL',
      );
    }

    // Insert outlet with answers
    Future<void> insertOutletWithAnswers({required Map<String, dynamic> data}) async {
      final db = await database;

      await db.transaction((txn) async {
        try {
          // 1. Insert outlet
          await txn.insert(
            'outlets',
            {
              'id': data['id'],
              'name': data['outletName'],
              'category': data['category'],
              'longitude': data['longitude'],
              'latitude': data['latitude'],
              'address': data['address'],
              'status': data['status'],
              'data_source': data['data_source'],
              'is_synced': data['is_synced'],
              'created_at': data['created_at'],
              'updated_at': data['updated_at'],
              'deleted_at': null,
            },
          );

          // 2. Insert form answers
          final formKeys = data.keys.where((key) => key.startsWith('form_id_')).toList();

          for (var key in formKeys) {
            final formId = key.replaceFirst('form_id_', '');
            await txn.insert(
              'outlet_form_answers',
              {
                'id': const Uuid().v4(),
                'outlet_id': data['id'],
                'outlet_form_id': formId,
                'answer': data[key],
                'created_at': data['created_at'],
                'updated_at': data['updated_at'],
                'deleted_at': null,
              },
            );
          }
        } catch (e) {
          print('Error inserting outlet with answers: $e');
          rethrow;
        }
      });
    }
  }
