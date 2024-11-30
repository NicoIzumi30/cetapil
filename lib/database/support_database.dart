import 'package:cetapil_mobile/model/list_product_sku_response.dart' as SKU;
import '../model/list_category_response.dart' as Category;
import '../model/list_channel_response.dart' as Channel;
import '../model/list_knowledge_response.dart' as Knowledge;
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
    ///SKU
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
        md_price REAL DEFAULT 0,
        sales_price REAL DEFAULT 0,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // New table for channel_av3m data
    await db.execute('''
      CREATE TABLE product_channels(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id TEXT,
        channel_name TEXT,
        value INTEGER,
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    ///CATEGORY
    await db.execute('''
    CREATE TABLE category(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');

    ///CHANNEL
    await db.execute('''
    CREATE TABLE channel(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');

    ///Knowledge
    await db.execute('''
    CREATE TABLE knowledge(
      id TEXT PRIMARY KEY,
        channel_id TEXT,
        path_pdf TEXT,
        path_video TEXT,
        FOREIGN KEY (channel_id) REFERENCES knowledge_channel (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE knowledge_channel(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');
  }

  Future<void> insertProduct(SKU.Data product) async {
    final db = await database;
    await db.transaction((txn) async {
      // Insert category
      await txn.insert(
        'categories',
        {'id': product.category!.id, 'name': product.category!.name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert product
      await txn.insert(
        'products',
        {
          'id': product.id,
          'sku': product.sku,
          'category_id': product.category!.id,
          'average_stock': product.averageStock,
          'md_price': product.mdPrice,
          'sales_price': product.salesPrice,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Insert channel_av3m data if it exists
      if (product.channelAv3M != null && product.channelAv3M is Map) {
        // Delete existing channel data for this product
        await txn.delete(
          'product_channels',
          where: 'product_id = ?',
          whereArgs: [product.id],
        );

        // Insert new channel data
        final Map<String, dynamic> channelMap =
            Map<String, dynamic>.from(product.channelAv3M as Map);
        for (var entry in channelMap.entries) {
          await txn.insert(
            'product_channels',
            {
              'product_id': product.id,
              'channel_name': entry.key,
              'value': entry.value,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> products = await db.query('products');
    final List<Map<String, dynamic>> result = [];

    for (var product in products) {
      // Get category data
      final category = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [product['category_id']],
      );

      // Get channel data
      final channels = await db.query(
        'product_channels',
        where: 'product_id = ?',
        whereArgs: [product['id']],
      );

      // Convert channel data to map
      Map<String, dynamic> channelAv3m = {};
      for (var channel in channels) {
        channelAv3m[channel['channel_name'] as String] = channel['value'];
      }
      print("channel : ${channels}");

      result.add({
        'id': product['id'],
        'sku': product['sku'],
        'average_stock': product['average_stock'],
        'md_price': product['md_price'],
        'sales_price': product['sales_price'],
        'category': category.first,
        'channel_av3m': channelAv3m,
      });
    }

    return result;
  }

  Future<void> insertCategory(Category.Data category) async {
    final db = await database;
    await db.insert(
      'category',
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');

    return maps;
  }

  Future<void> insertChannel(Channel.Data category) async {
    final db = await database;
    await db.insert(
      'channel',
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Channel.Data>> getAllChannel() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('channel');

    return maps.map((map) => Channel.Data.fromJson(map)).toList();
  }

  ///Knowledge
  Future<void> insertKnowledge(Knowledge.Data knowledge) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
          'knowledge_channel', {'id': knowledge.channel!.id, 'name': knowledge.channel!.name},
          conflictAlgorithm: ConflictAlgorithm.replace);

      await txn.insert(
          'knowledge',
          {
            'id': knowledge.id,
            'channel_id': knowledge.channel!.id,
            'path_pdf': knowledge.pathPdf,
            'path_video': knowledge.pathVideo
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Map<String, dynamic>>> getAllKnowledge() async {
    final db = await database;
    final List<Map<String, dynamic>> knowledges = await db.query('knowledge');
    final List<Map<String, dynamic>> result = [];

    for (var knowledge in knowledges) {
      final channel = await db
          .query('knowledge_channel', where: 'id = ?', whereArgs: [knowledge['channel_id']]);

      result.add({
        'id': knowledge['id'],
        'path_pdf': knowledge['path_pdf'],
        'path_video': knowledge['path_video'],
        'knowledge_channel': channel.first
      });
    }

    return result;
  }
}
