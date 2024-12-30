import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class ActivityDatabaseHelper {
  static final ActivityDatabaseHelper instance = ActivityDatabaseHelper._internal();
  static Database? _database;
  final uuid = Uuid();

  factory ActivityDatabaseHelper() => instance;

  ActivityDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sales_activity.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Main sales activity table
    await db.execute('''
      CREATE TABLE sales_activity (
        id TEXT PRIMARY KEY,
        outlet_id TEXT,
        name TEXT,
        category TEXT,
        channel_id TEXT,
        channel_name TEXT,
        view_knowledge TEXT,
        time_availability TEXT,
        time_visibility TEXT,
        time_knowledge TEXT,
        time_survey TEXT,
        time_order TEXT,
        status TEXT,
        checked_in TEXT,
        checked_out TEXT
      )
    ''');

    // Availability items table
    await db.execute('''
      CREATE TABLE availability (
        id TEXT PRIMARY KEY,
        sales_activity_id TEXT,
        product_id TEXT, 
        category TEXT,
        availability_exist TEXT,
        stock_on_hand TEXT,
        stock_on_inventory TEXT,
        av3m TEXT,
        FOREIGN KEY (sales_activity_id) REFERENCES sales_activity (id)
      )
    ''');

    // Visibility items table
    await db.execute('''
      CREATE TABLE visibility_primary (
        id TEXT PRIMARY KEY,
        sales_activity_id TEXT,
        category TEXT,
        position TEXT,
        posm_type_id TEXT,
        posm_type_name TEXT,
        visual_type_id TEXT,
        visual_type_name TEXT,
        condition TEXT,
        shelf_width TEXT,
        shelving TEXT,
        image_visibility TEXT,
        FOREIGN KEY (sales_activity_id) REFERENCES sales_activity (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE visibility_secondary (
        id TEXT PRIMARY KEY,
        sales_activity_id TEXT,
        category TEXT,
        position TEXT,
        secondary_exist TEXT,
        display_type TEXT,
        display_image TEXT,
        FOREIGN KEY (sales_activity_id) REFERENCES sales_activity (id)
      )
    ''');

    // Survey items table
    await db.execute('''
      CREATE TABLE survey (
        id TEXT PRIMARY KEY,
        sales_activity_id TEXT,
        survey_id TEXT,
        answer TEXT,
        FOREIGN KEY (sales_activity_id) REFERENCES sales_activity (id)
      )
    ''');

    // Order items table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        sales_activity_id TEXT,
        product_id TEXT,
        category TEXT,
        jumlah TEXT,
        harga TEXT,
        FOREIGN KEY (sales_activity_id) REFERENCES sales_activity (id)
      )
    ''');
  }

  Future<bool> checkSalesActivityExists(String id) async {
    final db = await database;
    final result = await db.query(
      'sales_activity',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  // Insert methods
  Future<void> insertFullSalesActivity({
    required Map<String, dynamic> data,
    List<Map<String, dynamic>>? availabilityItems,
    List<Map<String, dynamic>>? visibilityPrimaryItems,
    List<Map<String, dynamic>>? visibilitySecondaryItems,
    List<Map<String, dynamic>>? surveyItems,
    List<Map<String, dynamic>>? orderItems,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      // Insert main sales activity
      await txn.insert('sales_activity', {
        'id': data['sales_activity_id'].toString(),
        'outlet_id': data['outlet_id'].toString(),
        'name': data['name'].toString(),
        'category': data['category'].toString(),
        'channel_id': data['channel_id'].toString(),
        'channel_name': data['channel_name'].toString(),
        'view_knowledge': data['views_knowledge'].toString(),
        'time_availability': data['time_availability'].toString(),
        'time_visibility': data['time_visibility'].toString(),
        'time_knowledge': data['time_knowledge'].toString(),
        'time_survey': data['time_survey'].toString(),
        'time_order': data['time_order'].toString(),
        'status': data['status'].toString(),
        'checked_in': data['checked_in'].toString(),
        'checked_out': data['checked_out'].toString(),
      });

      // Insert availability items
      if (availabilityItems != null) {
        for (var item in availabilityItems) {
          await txn.insert('availability', {
            'id': uuid.v4(),
            'product_id': item['id'].toString(),
            'category': item['category'].toString(),
            'availability_exist': item['availability_toggle'].toString(),
            'stock_on_hand': item['stock_on_hand'].toString(),
            'stock_on_inventory': item['stock_on_inventory'].toString(),
            'av3m': item['av3m'].toString(),
            'sales_activity_id': data['sales_activity_id'],
          });
        }
      }

      // Insert visibility items
      if (visibilityPrimaryItems != null) {
        for (var item in visibilityPrimaryItems) {
          await txn.insert('visibility_primary', {
            'id': uuid.v4(),
            'sales_activity_id': data['sales_activity_id'],
            'category': item['category'].toString(),
            'position': item['position'].toString(),
            'posm_type_id': item['posm_type_id'].toString(),
            'posm_type_name': item['posm_type_name'].toString(),
            'visual_type_id': item['visual_type_id'].toString(),
            'visual_type_name': item['visual_type_name'].toString(),
            'condition': item['condition'].toString().toUpperCase(),
            'shelf_width': item['shelf_width'].toString(),
            'shelving': item['shelving'].toString(),
            'image_visibility': item['image_visibility'].path,
          });
        }
      }

      if (visibilitySecondaryItems != null) {
        for (var item in visibilitySecondaryItems) {
          await txn.insert('visibility_secondary', {
            'id': uuid.v4(),
            'sales_activity_id': data['sales_activity_id'],
            'category': item['category'].toString(),
            'position': item['position'].toString(),
            'secondary_exist': item['secondary_exist'].toString(),
            'display_type': item['display_type'].toString(),
            'display_image': item['display_image'].path,
          });
        }
      }

      // Insert survey items
      if (surveyItems != null) {
        for (var item in surveyItems) {
          await txn.insert('survey', {
            'id': uuid.v4(),
            'survey_id': item['survey_question_id'].toString(),
            'answer': item['answer'].toString(),
            'sales_activity_id': data['sales_activity_id'],
          });
        }
      }

      // Insert order items
      if (orderItems != null) {
        for (var item in orderItems) {
          await txn.insert('orders', {
            'id': uuid.v4(),
            'product_id': item['id'],
            'category': item['category'],
            'jumlah': item['jumlah'].toString(),
            'harga': item['harga'].toString(),
            'sales_activity_id': data['sales_activity_id'],
          });
        }
      }
    });
  }

  // Get methods with relationships
  Future<Map<String, dynamic>?> getDetailSalesActivity(String salesActivityId) async {
    final db = await database;
    try {
      // Get main sales activity
      final List<Map<String, dynamic>> activity = await db.query(
        'sales_activity',
        where: 'id = ?',
        whereArgs: [salesActivityId],
      );

      if (activity.isEmpty) return null;

      // Get related items
      final List<Map<String, dynamic>> availability = await db.query(
        'availability',
        where: 'sales_activity_id = ?',
        whereArgs: [salesActivityId],
      );

      final List<Map<String, dynamic>> visibility_primary = await db.query(
        'visibility_primary',
        where: 'sales_activity_id = ?',
        whereArgs: [salesActivityId],
      );

      final List<Map<String, dynamic>> visibility_secondary = await db.query(
        'visibility_secondary',
        where: 'sales_activity_id = ?',
        whereArgs: [salesActivityId],
      );

      final List<Map<String, dynamic>> survey = await db.query(
        'survey',
        where: 'sales_activity_id = ?',
        whereArgs: [salesActivityId],
      );

      final List<Map<String, dynamic>> orders = await db.query(
        'orders',
        where: 'sales_activity_id = ?',
        whereArgs: [salesActivityId],
      );

      // Combine all data
      return {
        ...activity.first,
        'availabilityItems': availability,
        'visibilityPrimaryItems': visibility_primary,
        'visibilitySecondaryItems': visibility_secondary,
        'surveyItems': survey,
        'orderItems': orders,
      };
    } catch (e) {
      print('Error getting sales activity: $e');
      return null;
    }
  }

  Future<List<String>> getDraftActivityIds() async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.query(
      'sales_activity',
      columns: ['id'],
      where: 'status = ?',
      whereArgs: ['DRAFTED'],
    );

    return results.map((result) => result['id'] as String).toList();
  }

// Update Function
  Future<void> updateSalesActivity({
    required Map<String, dynamic> data,
    List<Map<String, dynamic>>? availabilityItems,
    List<Map<String, dynamic>>? visibilityPrimaryItems,
    List<Map<String, dynamic>>? visibilitySecondaryItems,
    List<Map<String, dynamic>>? surveyItems,
    List<Map<String, dynamic>>? orderItems,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      // Update main sales activity
      await txn.update(
        'sales_activity',
        {
          'outlet_id': data['outlet_id'].toString(),
          'name': data['name'].toString(),
          'category': data['category'].toString(),
          'channel_id': data['channel_id'].toString(),
          'channel_name': data['channel_name'].toString(),
          'view_knowledge': data['views_knowledge'].toString(),
          'time_availability': data['time_availability'].toString(),
          'time_visibility': data['time_visibility'].toString(),
          'time_knowledge': data['time_knowledge'].toString(),
          'time_survey': data['time_survey'].toString(),
          'time_order': data['time_order'].toString(),
          'status': data['status'].toString(),
          'checked_in': data['checked_in'].toString(),
          'checked_out': data['checked_out'].toString(),
        },
        where: 'id = ?',
        whereArgs: [data['sales_activity_id']],
      );

      // Update availability items
      if (availabilityItems != null) {
        // Delete existing items
        await txn.delete(
          'availability',
          where: 'sales_activity_id = ?',
          whereArgs: [data['sales_activity_id']],
        );
        // Insert new items
        for (var item in availabilityItems) {
          await txn.insert('availability', {
            'id': uuid.v4(),
            'product_id': item['id'].toString(),
            'category': item['category'].toString(),
            'availability_exist': item['availability_toggle'].toString(),
            'stock_on_hand': item['stock_on_hand'].toString(),
            'stock_on_inventory': item['stock_on_inventory'].toString(),
            'av3m': item['av3m'].toString(),
            'sales_activity_id': data['sales_activity_id'],
          });
        }
      }
      // Update visibility items
      if (visibilityPrimaryItems != null) {
        await txn.delete(
          'visibility_primary',
          where: 'sales_activity_id = ?',
          whereArgs: [data['sales_activity_id']],
        );
        for (var item in visibilityPrimaryItems) {
          await txn.insert('visibility_primary', {
            'id': uuid.v4(),
            'sales_activity_id': data['sales_activity_id'],
            'category': item['category'].toString(),
            'position': item['position'].toString(),
            'posm_type_id': item['posm_type_id'].toString(),
            'posm_type_name': item['posm_type_name'].toString(),
            'visual_type_id': item['visual_type_id'].toString(),
            'visual_type_name': item['visual_type_name'].toString(),
            'condition': item['condition'].toString().toUpperCase(),
            'shelf_width': item['shelf_width'].toString(),
            'shelving': item['shelving'].toString(),
            'image_visibility': item['image_visibility'].path,
          });
        }
      }

      if (visibilitySecondaryItems != null) {
        await txn.delete(
          'visibility_secondary',
          where: 'sales_activity_id = ?',
          whereArgs: [data['sales_activity_id']],
        );
        for (var item in visibilitySecondaryItems) {
          await txn.insert('visibility_secondary', {
            'id': uuid.v4(),
            'sales_activity_id': data['sales_activity_id'],
            'category': item['category'].toString(),
            'position': item['position'].toString(),
            'secondary_exist': item['secondary_exist'].toString(),
            'display_type': item['display_type'].toString(),
            'display_image': item['display_image'].path,
          });
        }
      }

      // Update survey items
      if (surveyItems != null) {
        await txn.delete(
          'survey',
          where: 'sales_activity_id = ?',
          whereArgs: [data['sales_activity_id']],
        );
        for (var item in surveyItems) {
          await txn.insert('survey', {
            'id': uuid.v4(),
            'survey_id': item['survey_question_id'].toString(),
            'answer': item['answer'].toString(),
            'sales_activity_id': data['sales_activity_id'],
          });
        }
      }
      // Update order items
      if (orderItems != null) {
        await txn.delete(
          'orders',
          where: 'sales_activity_id = ?',
          whereArgs: [data['sales_activity_id']],
        );
        for (var item in orderItems) {
          await txn.insert('orders', {
            'id': uuid.v4(),
            'product_id': item['id'],
            'category': item['category'],
            'jumlah': item['jumlah'].toString(),
            'harga': item['harga'].toString(),
            'sales_activity_id': data['sales_activity_id'],
          });
        }
      }
    });
  }

  // Delete methods
  Future<void> deleteSalesActivity(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      // Delete related records first
      await txn.delete('availability', where: 'sales_activity_id = ?', whereArgs: [id]);
      await txn.delete('visibility', where: 'sales_activity_id = ?', whereArgs: [id]);
      await txn.delete('survey', where: 'sales_activity_id = ?', whereArgs: [id]);
      await txn.delete('orders', where: 'sales_activity_id = ?', whereArgs: [id]);
      // Delete main record
      await txn.delete('sales_activity', where: 'id = ?', whereArgs: [id]);
    });
  }
}
