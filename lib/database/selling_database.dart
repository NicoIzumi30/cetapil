import 'package:cetapil_mobile/model/list_product_sku_response.dart' as SKU;
import 'package:cetapil_mobile/model/list_selling_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SellingDatabaseHelper {
  static final SellingDatabaseHelper instance = SellingDatabaseHelper._init();
  static Database? _database;

  SellingDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('selling_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT
      )
    ''');

    // Create selling_data table
    await db.execute('''
      CREATE TABLE selling_data (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        outlet_id TEXT,
        outlet_name TEXT,
        longitude TEXT,
        latitude TEXT,
        filename TEXT,
        image TEXT,
        created_at TEXT,
        is_drafted INTEGER DEFAULT 0,
        checked_in TEXT,
        checked_out TEXT,
        duration INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Create products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        selling_id TEXT,
        product_id TEXT,
        product_name TEXT,
        category_id TEXT,
        category_name TEXT,
        stock INTEGER,
        selling INTEGER,
        balance INTEGER,
        price INTEGER,
        qty INTEGER,
        total INTEGER,
        FOREIGN KEY (selling_id) REFERENCES selling_data (id)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns to selling_data table
      await db.execute('ALTER TABLE selling_data ADD COLUMN checked_in TEXT');
      await db.execute('ALTER TABLE selling_data ADD COLUMN checked_out TEXT');
      await db.execute('ALTER TABLE selling_data ADD COLUMN duration INTEGER DEFAULT 0');
      
      // Update products table to include more fields
      await db.execute('ALTER TABLE products ADD COLUMN category_id TEXT');
      await db.execute('ALTER TABLE products ADD COLUMN category_name TEXT');
      await db.execute('ALTER TABLE products ADD COLUMN qty INTEGER');
      await db.execute('ALTER TABLE products ADD COLUMN total INTEGER');
    }
  }

  // CRUD operations for User
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  // CRUD operations for Selling Data
  Future<String> insertSellingData(Data sellingData, bool isDrafted) async {
    final db = await database;

    // Insert user first if it exists
    if (sellingData.user != null) {
      await insertUser(sellingData.user!);
    }

    final sellingMap = {
      'id': sellingData.id,
      'user_id': sellingData.user?.id,
      'outlet_id': sellingData.outlet?.id,
      'outlet_name': sellingData.outlet?.name,
      'longitude': sellingData.longitude,
      'latitude': sellingData.latitude,
      'filename': sellingData.filename,
      'image': sellingData.image,
      'created_at': sellingData.createdAt,
      'is_drafted': isDrafted ? 1 : 0,
      'checked_in': sellingData.checkedIn,
      'checked_out': sellingData.checkedOut,
      'duration': sellingData.duration,
    };

    await db.insert('selling_data', sellingMap, 
      conflictAlgorithm: ConflictAlgorithm.replace);

    // Insert associated products
    if (sellingData.products != null) {
      for (var product in sellingData.products!) {
        final productMap = {
          'id': product.id,
          'selling_id': sellingData.id,
          'product_id': product.productId,
          'product_name': product.productName,
          'category_id': product.category?.id,
          'category_name': product.category?.name,
          'price': product.price,
          'qty': product.qty,
          'total': product.total,
        };

        await db.insert('products', productMap, 
          conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    return sellingData.id!;
  }

  Future<List<Data>> getAllSellingData({bool? isDrafted}) async {
    final db = await database;

    String query = '''
      SELECT s.*, u.id as user_id, u.name as user_name 
      FROM selling_data s
      LEFT JOIN users u ON s.user_id = u.id
    ''';

    if (isDrafted != null) {
      query += ' WHERE s.is_drafted = ${isDrafted ? 1 : 0}';
    }

    final sellingMaps = await db.rawQuery(query);
    List<Data> sellingList = [];

    for (var sellingMap in sellingMaps) {
      // Create user object
      final user = User(
        id: sellingMap['user_id'] as String?,
        name: sellingMap['user_name'] as String?,
      );

      // Get associated products
      final productMaps = await db.query('products', 
        where: 'selling_id = ?', 
        whereArgs: [sellingMap['id']]
      );
      final products = productMaps.map((map) {
        return Products(
          id: map['id'] as String?,
          productId: map['product_id'] as String?,
          category: Category(
            id: map['category_id'] as String?,
            name: map['category_name'] as String?,
          ),
          productName: map['product_name'] as String?,
          qty: map['qty'] as int?,
          price: map['price'] as int?,
          total: map['total'] as int?,
        );
      }).toList();

      // Create selling data object with new columns
      final sellingData = Data(
        id: sellingMap['id'] as String?,
        user: user,
        outlet: Outlet(
          id: sellingMap['outlet_id'] as String?,
          name: sellingMap['outlet_name'] as String?,
        ),
        longitude: sellingMap['longitude'] as String?,
        latitude: sellingMap['latitude'] as String?,
        filename: sellingMap['filename'] as String?,
        image: sellingMap['image'] as String?,
        createdAt: sellingMap['created_at'] as String?,
        products: products,
        // Add new columns
        checkedIn: sellingMap['checked_in'] as String?,
        checkedOut: sellingMap['checked_out'] as String?,
        duration: sellingMap['duration'] as int?,
      );

      sellingList.add(sellingData);
    }

    return sellingList;
  }

  Future<void> deleteSellingData(String id) async {
    final db = await database;

    // Delete associated products first
    await db.delete('products', where: 'selling_id = ?', whereArgs: [id]);

    // Then delete the selling data
    await db.delete('selling_data', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSellingData(Data sellingData, bool isDrafted) async {
    await deleteSellingData(sellingData.id!);
    await insertSellingData(sellingData, isDrafted);
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}