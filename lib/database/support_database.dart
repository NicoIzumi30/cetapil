import 'package:cetapil_mobile/model/list_product_sku_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SupportDatabaseHelper {
  static final SupportDatabaseHelper instance = SupportDatabaseHelper._init();
  static Database? _database;

  SupportDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('data_support.db');
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
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        sku TEXT,
        category_id TEXT,
        average_stock INTEGER DEFAULT 0,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
  }

  Future<void> insertProduct(Data product) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('categories', {
        'id': product.category!.id,
        'name': product.category!.name
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      await txn.insert('products', {
        'id': product.id,
        'sku': product.sku,
        'category_id': product.category!.id,
        'average_stock': product.averageStock
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> products = await db.query('products');
    final List<Map<String, dynamic>> result = [];

    for (var product in products) {
      final category = await db.query(
          'categories',
          where: 'id = ?',
          whereArgs: [product['category_id']]
      );

      result.add({
        'id': product['id'],
        'sku': product['sku'],
        'average_stock': product['average_stock'],
        'category': category.first
      });
    }

    return result;
  }
}