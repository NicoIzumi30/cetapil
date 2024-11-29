import 'package:cetapil_mobile/model/outlet.dart' as Outlet;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../model/list_routing_response.dart' as Routing;
import '../model/list_activity_response.dart' as Activity;

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
    ///Tabel OUTLET
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

    ///TABLE ROUTING
    await db.execute('''
        CREATE TABLE routing (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          user_name TEXT,
          category TEXT,
          city_id TEXT,
          city_name TEXT,
          longitude TEXT,
          latitude TEXT,
          address TEXT,
          status TEXT CHECK(status IN ('APPROVED', 'PENDING', 'REJECTED')),
          
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          deleted_at TEXT
        )
      ''');
    await db.execute('''
        CREATE TABLE routing_images (
          id TEXT PRIMARY KEY,
          routing_id TEXT NOT NULL,
          position INTEGER,
          image TEXT,
          created_at TEXT NOT NULL,
          FOREIGN KEY (routing_id) REFERENCES routing (id)
        )
      ''');
    await db.execute('''
        CREATE TABLE routing_form_answers (
          id TEXT PRIMARY KEY,
          routing_id TEXT NOT NULL,
          outlet_form_id TEXT NOT NULL,
          answer TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          deleted_at TEXT,
          FOREIGN KEY (routing_id) REFERENCES routing (id),
          FOREIGN KEY (outlet_form_id) REFERENCES outlet_forms (id)
        )
      ''');
    await db.execute('''
        CREATE TABLE routing_activities (
          id TEXT PRIMARY KEY,
          routing_id TEXT ,
          outlet_id TEXT,
          user_id TEXT,
          checked_in TEXT ,
          checked_out TEXT ,
          views_knowledge INTEGER DEFAULT 0,
          time_availability INTEGER DEFAULT 0,
          time_visibility INTEGER DEFAULT 0,
          time_knowledge INTEGER DEFAULT 0,
          time_survey INTEGER DEFAULT 0,
          time_order INTEGER DEFAULT 0,
          status TEXT CHECK(status IN ('IN_PROGRESS', 'SUBMITTED', 'CANCELLED')) DEFAULT 'IN_PROGRESS',
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          deleted_at TEXT,
          FOREIGN KEY (outlet_id) REFERENCES outlets (id)
          FOREIGN KEY (routing_id) REFERENCES routing (id)
        )
      ''');

    /// TABLE ACTIVITY
    await db.execute('''
  CREATE TABLE outlet_activities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    city_id TEXT,
    longitude TEXT,
    latitude TEXT,
    visit_day TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
  )
''');

    await db.execute('''
  CREATE TABLE sales_activities (
    id TEXT PRIMARY KEY,
    outlet_id TEXT NOT NULL,
    checked_in TEXT,
    checked_out TEXT,
    views_knowledge INTEGER DEFAULT 0,
    time_availability INTEGER DEFAULT 0,
    time_visibility INTEGER DEFAULT 0,
    time_knowledge INTEGER DEFAULT 0,
    time_survey INTEGER DEFAULT 0,
    time_order INTEGER DEFAULT 0,
    status TEXT CHECK(status IN ('IN_PROGRESS', 'SUBMITTED', 'CANCELLED')) DEFAULT 'IN_PROGRESS',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT,
    FOREIGN KEY (outlet_id) REFERENCES outlet_activities (id)
  )
''');
  }

  // Delete entire database
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'outlet_database.db');
    await databaseFactory.deleteDatabase(path);
  }

  // Insert or update outlet from API
  Future<void> upsertOutletFromApi(Outlet.Outlet outlet) async {
    final db = await database;

    await db.transaction((txn) async {
      // Check if this is a draft before upserting
      final List<Map<String, dynamic>> existing = await txn.query(
        'outlets',
        where: 'id = ?',
        whereArgs: [outlet.id],
      );

      final bool isDraft = existing.isNotEmpty && existing.first['data_source'] == 'DRAFT';

      // Insert/Update main outlet data, preserving draft status if it exists
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
          'data_source': isDraft ? 'DRAFT' : outlet.dataSource ?? 'API',
          'is_synced': isDraft ? 0 : 1,
          'created_at':
              existing.isNotEmpty ? existing.first['created_at'] : DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Only update images and forms if it's not a draft
      if (!isDraft) {
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
      }
    });
  }

  // Insert draft outlet
  Future<String> insertDraftOutlet(Outlet.Outlet outlet) async {
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
  Future<List<Outlet.Outlet>> getAllOutlets({String? dataSource}) async {
    final db = await database;

    final List<Map<String, dynamic>> outletMaps = await db.query(
      'outlets',
      where: dataSource != null ? 'data_source = ?' : null,
      whereArgs: dataSource != null ? [dataSource] : null,
    );

    return Future.wait(outletMaps.map((outletMap) async {
      // print("Raw outlet data from DB: $outletMap"); // Debug print

      // Get images for this outlet
      final List<Map<String, dynamic>> imageMaps = await db.query(
        'outlet_images',
        where: 'outlet_id = ?',
        whereArgs: [outletMap['id']],
      );

      // Get forms with their answers for this outlet
      final List<Map<String, dynamic>> formMaps = await db.rawQuery('''
      SELECT 
        fa.id,
        f.id as outlet_form_id,
        f.type,
        f.question,
        fa.answer
      FROM outlet_forms f
      INNER JOIN outlet_form_answers fa ON f.id = fa.outlet_form_id
      WHERE fa.outlet_id = ?
    ''', [outletMap['id']]);

      final outlet = Outlet.Outlet(
        id: outletMap['id'],
        user: Outlet.User(
          id: outletMap['user_id']?.toString() ?? '',
          name: outletMap['user_name']?.toString() ??
              outletMap['salesName']?.toString() ??
              '', // Try both fields
        ),
        name: outletMap['name'],
        category: outletMap['category'],
        visitDay: outletMap['visit_day'],
        longitude: outletMap['longitude'],
        latitude: outletMap['latitude'],
        city: Outlet.City(
          id: outletMap['city_id']?.toString() ?? '',
          name: outletMap['city_name']?.toString() ?? '',
        ),
        address: outletMap['address'],
        status: outletMap['status'],
        weekType: outletMap['week_type'],
        cycle: outletMap['cycle'],
        salesActivity: outletMap['sales_activity'],
        dataSource: outletMap['data_source'],
        isSynced: outletMap['is_synced'] == 1,
        images: imageMaps
            .map((imageMap) => Outlet.Images(
                  id: imageMap['id'] as String?,
                  position: imageMap['position'] as int?,
                  filename: imageMap['filename'] as String?,
                  image: imageMap['image'] as String?,
                ))
            .toList(),
        forms: formMaps
            .map((formMap) => Outlet.Forms(
                  id: formMap['id'] as String?,
                  outletForm: Outlet.OutletForm(
                    id: formMap['outlet_form_id'] as String?,
                    type: formMap['type'] as String?,
                    question: formMap['question'] as String?,
                  ),
                  answer: formMap['answer'] as String?,
                ))
            .toList(),
      );

      // print("Created outlet object: $outlet"); // Debug print
      return outlet;
    }));
  }

  // Get unsynchronized draft outlets
  Future<List<Outlet.Outlet>> getUnsyncedDraftOutlets() async {
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
            'user_id': null, // Add this
            'user_name': data['salesName'], // Change this from user_name
            'category': data['category'],
            'city_id': data['city_id'], // Added
            'city_name': data['city_name'], // Added
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

        for (int i = 0; i < 3; i++) {
          await txn.insert(
            'outlet_images',
            {
              'id': const Uuid().v4(),
              'outlet_id': data['id'],
              'position': "${i + 1}",
              'filename': data['filename_${i + 1}'],
              'image': data['image_path_${i + 1}'],
              'created_at': DateTime.now().toIso8601String(),
            },
          );
        }
        // final imageKeys =
        // data.keys.where((key) => key.startsWith('image')).toList();
        // for (var key in imageKeys) {
        //   String? position;
        //   switch (key) {
        //     case "image_front":
        //       position = '1';
        //       break;
        //     case "image_banner":
        //       position = '2';
        //       break;
        //     case "image_landmark":
        //       position = '3';
        //       break;
        //   }
        //   await txn.insert(
        //     'outlet_images',
        //     {
        //       'id': const Uuid().v4(),
        //       'outlet_id': data['id'],
        //       'position': position,
        //       'filename': data,
        //       'image': data[key],
        //       'created_at': DateTime.now().toIso8601String(),
        //     },
        //   );
        // }

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

  Future<void> updateOutlet({required Map<String, dynamic> data}) async {
    final db = await database;

    await db.transaction((txn) async {
      try {
        print("Updating outlet with data: ${data.toString()}");

        // 1. Update the outlet
        await txn.rawUpdate('''
        UPDATE outlets 
        SET name = ?, 
            user_name = ?,
            category = ?,
            city_id = ?,
            city_name = ?,
            longitude = ?,
            latitude = ?,
            address = ?,
            status = ?,
            data_source = ?,
            is_synced = ?,
            updated_at = ?
        WHERE id = ?
      ''', [
          data['outletName'],
          data['salesName'], // Make sure this matches
          data['category'],
          data['city_id'],
          data['city_name'],
          data['longitude'],
          data['latitude'],
          data['address'],
          data['status'],
          'DRAFT', // Added this
          0, // Added this
          data['updated_at'],
          data['id'],
        ]);

        print("After update, retrieving outlet...");
        final List<Map<String, dynamic>> updated = await txn.query(
          'outlets',
          where: 'id = ?',
          whereArgs: [data['id']],
        );
        print("Updated outlet data: ${updated.first}");

        // 2. Delete old images
        await txn.delete('outlet_images', where: 'outlet_id = ?', whereArgs: [data['id']]);

        // 3. Insert new images
        for (int i = 0; i < 3; i++) {
          if (data['image_path_${i + 1}'] != null && data['image_path_${i + 1}'].isNotEmpty) {
            await txn.insert('outlet_images', {
              'id': const Uuid().v4(),
              'outlet_id': data['id'],
              'position': i + 1,
              'filename': data['filename_${i + 1}'],
              'image': data['image_path_${i + 1}'],
              'created_at': DateTime.now().toIso8601String(),
            });
          }
        }

        // 4. Delete old form answers
        await txn.delete('outlet_form_answers', where: 'outlet_id = ?', whereArgs: [data['id']]);

        // 5. Insert new form answers
        final formKeys = data.keys.where((key) => key.startsWith('form_id_')).toList();
        for (var key in formKeys) {
          final formId = key.replaceFirst('form_id_', '');
          await txn.insert('outlet_form_answers', {
            'id': const Uuid().v4(),
            'outlet_id': data['id'],
            'outlet_form_id': formId,
            'answer': data[key],
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': data['updated_at'],
          });
        }

        print("Update completed successfully");
      } catch (e) {
        print('Error updating outlet: $e');
        rethrow;
      }
    });
  }

  ///ROUTING

  Future<void> deleteAllRouting() async {
    final db = await database;
    await db.transaction((txn) async {
      // Delete from child tables first
      await txn.delete('routing_form_answers');
      await txn.delete('routing_images');
      await txn.delete('routing_activities');

      // Then delete from parent table
      await txn.delete('routing');
    });
  }

  Future<void> insertRoutingWithAnswers({required Map<String, dynamic> data}) async {
    final db = await database;

    await db.transaction((txn) async {
      try {
        // 1. Insert routing
        await txn.insert(
          'routing',
          {
            'id': data['id'],
            'name': data['outletName'],
            'user_name': data['salesName'],
            'category': data['category'],
            'city_id': data['city_id'],
            'city_name': data['city_name'],
            'longitude': data['longitude'],
            'latitude': data['latitude'],
            'address': data['address'],
            'status': data['status_outlet'],
            'created_at': data['created_at'],
            'updated_at': data['updated_at'],
            'deleted_at': null,
          },
        );

        // 2. Only insert activities if sales_activity data exists
        if (data.containsKey('activities_id')) {
          await txn.insert(
            'routing_activities',
            {
              'id': data['activities_id'],
              'routing_id': data['id'],
              'outlet_id': data['outlet_id'],
              'user_id': data['user_id'],
              'checked_in': data['checked_in'] ?? DateTime.now().toIso8601String(),
              'checked_out': data['checked_out'],
              'views_knowledge': data['views_knowledge'] ?? 0,
              'time_availability': data['time_availability'] ?? 0,
              'time_visibility': data['time_visibility'] ?? 0,
              'time_knowledge': data['time_knowledge'] ?? 0,
              'time_survey': data['time_survey'] ?? 0,
              'time_order': data['time_order'] ?? 0,
              'status': data['status_activities'],
              'created_at': data['created_at'],
              'updated_at': data['updated_at'],
              'deleted_at': null,
            },
          );
        }

        // 3. Insert routing images
        for (int i = 0; i < 3; i++) {
          if (data['image_path_${i + 1}'] != null) {
            await txn.insert(
              'routing_images',
              {
                'id': const Uuid().v4(),
                'routing_id': data['id'],
                'position': i + 1,
                'image': data['image_path_${i + 1}'],
                'created_at': DateTime.now().toIso8601String(),
              },
            );
          }
        }

        // 4. Insert routing form answers
        final formKeys = data.keys.where((key) => key.startsWith('form_id_')).toList();
        for (var key in formKeys) {
          final formId = key.replaceFirst('form_id_', '');
          if (data[key] != null && data[key].toString().isNotEmpty) {
            await txn.insert(
              'routing_form_answers',
              {
                'id': const Uuid().v4(),
                'routing_id': data['id'],
                'outlet_form_id': formId,
                'answer': data[key],
                'created_at': data['created_at'],
                'updated_at': data['updated_at'],
                'deleted_at': null,
              },
            );
          }
        }
      } catch (e) {
        print('Error in transaction: $e');
        rethrow;
      }
    });
  }

  Future<List<Routing.Data>> getAllRouting() async {
    final db = await database;

    final List<Map<String, dynamic>> routingMaps = await db.query(
      'routing',
    );

    return Future.wait(routingMaps.map((routingMap) async {
      // print("Raw outlet data from DB: $outletMap"); // Debug print

      // Get images for this outlet
      final List<Map<String, dynamic>> imageMaps = await db.query(
        'routing_images',
        where: 'routing_id = ?',
        whereArgs: [routingMap['id']],
      );

      final activityMaps = await db.query(
        'routing_activities',
        where: 'routing_id = ?',
        whereArgs: [routingMap['id']],
      );

      // Get forms with their answers for this outlet
      final List<Map<String, dynamic>> formMaps = await db.rawQuery('''
      SELECT 
        fa.id,
        f.id as outlet_form_id,
        f.type,
        f.question,
        fa.answer
      FROM outlet_forms f
      INNER JOIN routing_form_answers fa ON f.id = fa.outlet_form_id
      WHERE fa.routing_id = ?
    ''', [routingMap['id']]);

      final routing = Routing.Data(
        id: routingMap['id'],
        user: Routing.User(
          id: routingMap['user_id']?.toString() ?? '',
          name: routingMap['salesName']?.toString() ?? '',
        ),
        name: routingMap['name'],
        category: routingMap['category'],
        visitDay: routingMap['visit_day'],
        longitude: routingMap['longitude'],
        latitude: routingMap['latitude'],
        city: Routing.City(
          id: routingMap['city_id']?.toString() ?? '',
          name: routingMap['city_name']?.toString() ?? '',
        ),
        address: routingMap['address'],
        status: routingMap['status'],
        salesActivity:
            activityMaps.isNotEmpty ? Routing.SalesActivity.fromMap(activityMaps.first) : null,
        images: imageMaps
            .map((imageMap) => Routing.Images(
                  id: imageMap['id'] as String?,
                  position: imageMap['position'] as int?,
                  image: imageMap['image'] as String?,
                ))
            .toList(),
        forms: formMaps
            .map((formMap) => Routing.Forms(
                  id: formMap['id'] as String?,
                  outletForm: Routing.OutletForm(
                    id: formMap['outlet_form_id'] as String?,
                    type: formMap['type'] as String?,
                    question: formMap['question'] as String?,
                  ),
                  answer: formMap['answer'] as String?,
                ))
            .toList(),
      );

      // print("Created outlet object: $outlet"); // Debug print
      return routing;
    }));
  }

  /// ACTIVITY
  Future<void> deleteAllActivity() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('outlet_activities');
      await txn.delete('sales_activities');
    });
  }

  Future<void> insertActivity(Map<String, dynamic> data) async {
    final db = await database;

    await db.transaction((txn) async {
      // Insert outlet
      // final outlet = data['outlet'];
      await txn.insert(
        'outlet_activities',
        {
          'id': data['outlet_id'],
          'name': data['name'],
          'category': data['category'],
          'city_id': data['city_id'],
          'longitude': data['longitude'],
          'latitude': data['latitude'],
          'visit_day': data['visit_day'],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert sales activity
      await txn.insert(
        'sales_activities',
        {
          'id': data['id'],
          'outlet_id': data['outlet_id'],
          'checked_in': data['checked_in'],
          'checked_out': data['checked_out'],
          'views_knowledge': data['views_knowledge'],
          'time_availability': data['time_availability'],
          'time_visibility': data['time_visibility'],
          'time_knowledge': data['time_knowledge'],
          'time_survey': data['time_survey'],
          'time_order': data['time_order'],
          'status': data['status'],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<Activity.Data>> getSalesActivities() async {
    final db = await database;

    final List<Map<String, dynamic>> activityMaps = await db.query(
      'sales_activities',
    );

    return Future.wait(activityMaps.map((activityMap) async {
      final outletMaps = await db.query(
        'outlet_activities',
        where: 'id = ?',
        whereArgs: [activityMap['outlet_id']],
      );

      final activities = Activity.Data(
        id: activityMap['id'],
        outlet: outletMaps.isNotEmpty ? Activity.Outlet.fromJson(outletMaps.first) : null,
        checkedIn: activityMap['checked_in'],
        checkedOut: activityMap['checked_out'],
        viewsKnowledge: activityMap['views_knowledge'],
        timeAvailability: activityMap['time_availability'],
        timeVisibility: activityMap['time_visibility'],
        timeKnowledge: activityMap['time_knowledge'],
        timeSurvey: activityMap['time_survey'],
        timeOrder: activityMap['time_order'],
        status: activityMap['status'],
      );

      return activities;
    }));
  }

  // Add this method to your DatabaseHelper class
// Add this method to your DatabaseHelper class
  Future<Outlet.Outlet?> getOutletById(String id) async {
    final db = await database;

    try {
      // Get the main outlet data
      final List<Map<String, dynamic>> outletMaps = await db.query(
        'outlets',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (outletMaps.isEmpty) {
        return null;
      }

      final outletMap = outletMaps.first;

      // Get images for this outlet
      final List<Map<String, dynamic>> imageMaps = await db.query(
        'outlet_images',
        where: 'outlet_id = ?',
        whereArgs: [id],
      );

      // Get forms with their answers for this outlet
      final List<Map<String, dynamic>> formMaps = await db.rawQuery('''
      SELECT 
        fa.id,
        f.id as outlet_form_id,
        f.type,
        f.question,
        fa.answer
      FROM outlet_forms f
      INNER JOIN outlet_form_answers fa ON f.id = fa.outlet_form_id
      WHERE fa.outlet_id = ?
    ''', [id]);

      // Convert to JSON format that matches your model
      final Map<String, dynamic> outletJson = {
        'id': outletMap['id'],
        'user': outletMap['user_id'] != null
            ? {
                'id': outletMap['user_id'],
                'name': outletMap['user_name'],
              }
            : null,
        'name': outletMap['name'],
        'category': outletMap['category'],
        'visit_day': outletMap['visit_day'],
        'longitude': outletMap['longitude'],
        'latitude': outletMap['latitude'],
        'city': outletMap['city_id'] != null
            ? {
                'id': outletMap['city_id'],
                'name': outletMap['city_name'],
              }
            : null,
        'address': outletMap['address'],
        'status': outletMap['status'],
        'week_type': outletMap['week_type'],
        'cycle': outletMap['cycle'],
        'sales_activity': outletMap['sales_activity'],
        'data_source': outletMap['data_source'],
        'is_synced': outletMap['is_synced'] == 1,
        'images': imageMaps
            .map((imageMap) => {
                  'id': imageMap['id'],
                  'position': imageMap['position'],
                  'filename': imageMap['filename'],
                  'image': imageMap['image'],
                })
            .toList(),
        'forms': formMaps
            .map((formMap) => {
                  'id': formMap['id'],
                  'outletForm': {
                    'id': formMap['outlet_form_id'],
                    'type': formMap['type'],
                    'question': formMap['question'],
                  },
                  'answer': formMap['answer'],
                })
            .toList(),
      };

      return Outlet.Outlet.fromJson(outletJson);
    } catch (e) {
      print('Error in getOutletById: $e');
      return null;
    }
  }
}
