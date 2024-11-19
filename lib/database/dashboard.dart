import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/dashboard.dart'; // Adjust import path as needed

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
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      print('Error initializing dashboard database: $e');
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    // Create current_outlets table
    await db.execute('''
      CREATE TABLE current_outlets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        outlet_id TEXT,
        sales_activity_id TEXT,
        name TEXT,
        checked_in TEXT,
        checked_out TEXT
      )
    ''');

    // Create dashboard_data table
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
        current_outlet_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (current_outlet_id) REFERENCES current_outlets (id)
      )
    ''');
  }

  // Save Dashboard Data
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
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Insert dashboard data
        await txn.insert(
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
            'current_outlet_id': currentOutletId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print('Error saving dashboard data: $e');
        rethrow;
      }
    });
  }

  // Get Latest Dashboard Data
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
          c.checked_out
        FROM dashboard_data d
        LEFT JOIN current_outlets c ON d.current_outlet_id = c.id
        ORDER BY d.created_at DESC
        LIMIT 1
      ''');

      if (results.isEmpty) return null;

      final row = results.first;
      
      // Construct CurrentOutlet
      final currentOutlet = CurrentOutlet(
        outletId: row['outlet_id'],
        salesActivityId: row['sales_activity_id'],
        name: row['outlet_name'] as String?,
        checkedIn: row['checked_in'],
        checkedOut: row['checked_out'],
      );

      // Construct Data
      final data = Data(
        city: row['city'],
        region: row['region'],
        role: row['role'] as String?,
        totalOutlet: row['total_outlet'] as int?,
        totalActualPlan: row['total_actual_plan'] as int?,
        totalCallPlan: row['total_call_plan'] as int?,
        planPercentage: row['plan_percentage'] as int?,
        currentOutlet: currentOutlet,
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

  // Update Dashboard Data
  Future<void> updateDashboard(Dashboard dashboard) async {
    final db = await database;
    
    await db.transaction((txn) async {
      try {
        // Update or insert current outlet
        if (dashboard.data?.currentOutlet != null) {
          await txn.insert(
            'current_outlets',
            {
              'outlet_id': dashboard.data!.currentOutlet!.outletId,
              'sales_activity_id': dashboard.data!.currentOutlet!.salesActivityId,
              'name': dashboard.data!.currentOutlet!.name,
              'checked_in': dashboard.data!.currentOutlet!.checkedIn,
              'checked_out': dashboard.data!.currentOutlet!.checkedOut,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Update dashboard data
        await txn.insert(
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
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print('Error updating dashboard data: $e');
        rethrow;
      }
    });
  }

  // Clear All Dashboard Data
  Future<void> clearDashboard() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('current_outlets');
      await txn.delete('dashboard_data');
    });
  }

  // Get Dashboard History (Optional)
  Future<List<Dashboard>> getDashboardHistory({int limit = 10}) async {
    final db = await database;
    
    try {
      final results = await db.rawQuery('''
        SELECT 
          d.*,
          c.outlet_id,
          c.sales_activity_id,
          c.name as outlet_name,
          c.checked_in,
          c.checked_out
        FROM dashboard_data d
        LEFT JOIN current_outlets c ON d.current_outlet_id = c.id
        ORDER BY d.created_at DESC
        LIMIT ?
      ''', [limit]);

      return results.map((row) {
        final currentOutlet = CurrentOutlet(
          outletId: row['outlet_id'],
          salesActivityId: row['sales_activity_id'],
          name: row['outlet_name'] as String?,
          checkedIn: row['checked_in'],
          checkedOut: row['checked_out'],
        );

        final data = Data(
          city: row['city'],
          region: row['region'],
          role: row['role'] as String?,
          totalOutlet: row['total_outlet'] as int?,
          totalActualPlan: row['total_actual_plan'] as int?,
          totalCallPlan: row['total_call_plan'] as int?,
          planPercentage: row['plan_percentage'] as int?,
          currentOutlet: currentOutlet,
        );

        return Dashboard(
          status: row['status'] as String?,
          message: row['message'] as String?,
          data: data,
        );
      }).toList();
    } catch (e) {
      print('Error getting dashboard history: $e');
      rethrow;
    }
  }
}