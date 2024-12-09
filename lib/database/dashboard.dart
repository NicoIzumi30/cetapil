import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/dashboard.dart';

class DashboardDatabaseHelper {
  static final DashboardDatabaseHelper instance = DashboardDatabaseHelper._init();
  static Database? _database;

  DashboardDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dashboard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 4, // Increased version for location fields
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      print('Error initializing dashboard database: $e');
      rethrow;
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE power_skus (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dashboard_id INTEGER,
          sku TEXT,
          total_outlets INTEGER,
          available_count INTEGER,
          availability_percentage INTEGER,
          FOREIGN KEY (dashboard_id) REFERENCES dashboard_data (id)
        )
      ''');
    }
    
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE dashboard_data 
        ADD COLUMN last_performance_update TEXT
      ''');
      
      await db.execute('''
        ALTER TABLE dashboard_data 
        ADD COLUMN last_power_sku_update TEXT
      ''');
    }

    if (oldVersion < 4) {
      // Add location fields to current_outlets table
      await db.execute('''
        ALTER TABLE current_outlets 
        ADD COLUMN outlet_latitude TEXT
      ''');
      await db.execute('''
        ALTER TABLE current_outlets 
        ADD COLUMN outlet_longitude TEXT
      ''');
      await db.execute('''
        ALTER TABLE current_outlets 
        ADD COLUMN check_in_latitude TEXT
      ''');
      await db.execute('''
        ALTER TABLE current_outlets 
        ADD COLUMN check_in_longitude TEXT
      ''');
      await db.execute('''
        ALTER TABLE current_outlets 
        ADD COLUMN radius TEXT
      ''');
      await db.execute('''
        ALTER TABLE current_outlets 
        ADD COLUMN distance_to_outlet REAL
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE current_outlets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        outlet_id TEXT,
        sales_activity_id TEXT,
        name TEXT,
        checked_in TEXT,
        checked_out TEXT,
        outlet_latitude TEXT,
        outlet_longitude TEXT,
        check_in_latitude TEXT,
        check_in_longitude TEXT,
        radius TEXT,
        distance_to_outlet REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE dashboard_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        status TEXT,
        message TEXT,
        city TEXT,
        region TEXT,
        role TEXT,
        total_outlet INTEGER,
        total_actual_plan INTEGER,
        total_call_plan INTEGER,
        plan_percentage INTEGER,
        last_performance_update TEXT,
        last_power_sku_update TEXT,
        current_outlet_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (current_outlet_id) REFERENCES current_outlets (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE power_skus (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dashboard_id INTEGER,
        sku TEXT,
        total_outlets INTEGER,
        available_count INTEGER,
        availability_percentage INTEGER,
        FOREIGN KEY (dashboard_id) REFERENCES dashboard_data (id)
      )
    ''');
  }

  Future<void> saveDashboard(Dashboard dashboard) async {
    final db = await database;
    
    await db.transaction((txn) async {
      try {
        // Insert current outlet if exists
        int? currentOutletId;
        if (dashboard.data?.currentOutlet != null) {
          currentOutletId = await txn.insert(
            'current_outlets',
            {
              'outlet_id': dashboard.data!.currentOutlet!.outletId,
              'sales_activity_id': dashboard.data!.currentOutlet!.salesActivityId,
              'name': dashboard.data!.currentOutlet!.name,
              'checked_in': dashboard.data!.currentOutlet!.checkedIn,
              'checked_out': dashboard.data!.currentOutlet!.checkedOut,
              'outlet_latitude': dashboard.data!.currentOutlet!.outletLatitude,
              'outlet_longitude': dashboard.data!.currentOutlet!.outletLongitude,
              'check_in_latitude': dashboard.data!.currentOutlet!.checkInLatitude,
              'check_in_longitude': dashboard.data!.currentOutlet!.checkInLongitude,
              'radius': dashboard.data!.currentOutlet!.radius,
              'distance_to_outlet': dashboard.data!.currentOutlet!.distanceToOutlet,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Insert dashboard data
        final dashboardId = await txn.insert(
          'dashboard_data',
          {
            'status': dashboard.status,
            'message': dashboard.message,
            'city': dashboard.data?.city,
            'region': dashboard.data?.region,
            'role': dashboard.data?.role,
            'total_outlet': dashboard.data?.totalOutlet,
            'total_actual_plan': dashboard.data?.totalActualPlan,
            'total_call_plan': dashboard.data?.totalCallPlan,
            'plan_percentage': dashboard.data?.planPercentage,
            'last_performance_update': dashboard.data?.lastPerformanceUpdate,
            'last_power_sku_update': dashboard.data?.lastPowerSkuUpdate,
            'current_outlet_id': currentOutletId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Insert power SKUs if they exist
        if (dashboard.data?.powerSkus != null) {
          for (var sku in dashboard.data!.powerSkus!) {
            await txn.insert(
              'power_skus',
              {
                'dashboard_id': dashboardId,
                'sku': sku.sku,
                'total_outlets': sku.totalOutlets,
                'available_count': sku.availableCount,
                'availability_percentage': sku.availabilityPercentage,
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        }
      } catch (e) {
        print('Error saving dashboard data: $e');
        rethrow;
      }
    });
  }

  Future<Dashboard?> getLatestDashboard() async {
    final db = await database;
    
    try {
      final results = await db.rawQuery('''
        SELECT 
          d.*,
          c.outlet_id,
          c.sales_activity_id,
          c.name as outlet_name,
          c.checked_in,
          c.checked_out,
          c.outlet_latitude,
          c.outlet_longitude,
          c.check_in_latitude,
          c.check_in_longitude,
          c.radius,
          c.distance_to_outlet
        FROM dashboard_data d
        LEFT JOIN current_outlets c ON d.current_outlet_id = c.id
        ORDER BY d.created_at DESC
        LIMIT 1
      ''');

      if (results.isEmpty) return null;

      final row = results.first;
      
      // Get power SKUs for this dashboard
      final powerSkusResults = await db.query(
        'power_skus',
        where: 'dashboard_id = ?',
        whereArgs: [row['id']],
      );

      final powerSkus = powerSkusResults.map((skuRow) => PowerSkus(
        sku: skuRow['sku'] as String?,
        totalOutlets: skuRow['total_outlets'] as int?,
        availableCount: skuRow['available_count'] as int?,
        availabilityPercentage: skuRow['availability_percentage'] as int?,
      )).toList();

      // Construct CurrentOutlet with location data
      final currentOutlet = row['outlet_id'] != null ? CurrentOutlet(
        outletId: row['outlet_id'],
        salesActivityId: row['sales_activity_id'],
        name: row['outlet_name'] as String?,
        checkedIn: row['checked_in'],
        checkedOut: row['checked_out'],
        outletLatitude: row['outlet_latitude'] as String?,
        outletLongitude: row['outlet_longitude'] as String?,
        checkInLatitude: row['check_in_latitude'] as String?,
        checkInLongitude: row['check_in_longitude'] as String?,
        radius: row['radius'] as String?,
        distanceToOutlet: row['distance_to_outlet'] as double?,
      ) : null;

      // Construct Data
      final data = Data(
        city: row['city'],
        region: row['region'],
        role: row['role'] as String?,
        totalOutlet: row['total_outlet'] as int?,
        totalActualPlan: row['total_actual_plan'] as int?,
        totalCallPlan: row['total_call_plan'] as int?,
        planPercentage: row['plan_percentage'] as int?,
        lastPerformanceUpdate: row['last_performance_update'] as String?,
        lastPowerSkuUpdate: row['last_power_sku_update'] as String?,
        currentOutlet: currentOutlet,
        powerSkus: powerSkus,
      );

      // Construct Dashboard
      return Dashboard(
        status: row['status'] as String?,
        message: row['message'] as String?,
        data: data,
      );
    } catch (e) {
      print('Error getting dashboard data: $e');
      rethrow;
    }
  }

  Future<void> clearDashboard() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('power_skus');
      await txn.delete('current_outlets');
      await txn.delete('dashboard_data');
    });
  }
}