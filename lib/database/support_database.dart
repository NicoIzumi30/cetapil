import 'package:cetapil_mobile/model/list_product_sku_response.dart' as SKU;
import '../model/list_category_response.dart' as Category;
import '../model/list_channel_response.dart' as Channel;
import '../model/list_knowledge_response.dart' as Knowledge;
import '../model/survey_question_response.dart' as Survey;
import '../model/list_posm_response.dart' as Posm;
import '../model/list_visual_response.dart' as Visual;
import '../model/list_planogram_response.dart' as Planogram;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../model/survey_question_response.dart';

class SupportDatabaseHelper {
  static final SupportDatabaseHelper instance = SupportDatabaseHelper._init();
  static Database? _database;

  SupportDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('data_support.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    try {
      await Directory(dirname(path)).create(recursive: true);
      await File(path).delete();
    } catch (e) {
      print('Setup error: $e');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      readOnly: false,
    );
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.transaction((txn) async {
      // Clear related tables first due to foreign key constraints
      await txn.delete('product_channels');
      await txn.delete('surveys');
      await txn.delete('products');
      await txn.delete('categories');
      await txn.delete('category');
      await txn.delete('channel');
      await txn.delete('knowledge');
      await txn.delete('knowledge_channel');
      await txn.delete('survey_questions');
      await txn.delete('posm_types');
      await txn.delete('visual_types');
      await txn.delete('planograms');
    });
  }

  Future<void> clearTable(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
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
        price REAL DEFAULT 0,
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
      path_pdf TEXT,
      path_video TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE knowledge_channel(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');

    ///Survey
    await db.execute('''
      CREATE TABLE survey_questions(
        id TEXT PRIMARY KEY,
        title TEXT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE surveys(
        id TEXT PRIMARY KEY,
        product_id TEXT,
        type TEXT,
        question TEXT,
        survey_question_id TEXT,
        FOREIGN KEY (survey_question_id) REFERENCES survey_questions(id)
      )
    ''');

    // Add POSM type table
    await db.execute('''
    CREATE TABLE posm_types(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');

    // Add Visual type table
    await db.execute('''
    CREATE TABLE visual_types(
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
    ''');

    await db.execute('''
      CREATE TABLE planograms(
        channel_id TEXT,
        path TEXT,
        FOREIGN KEY (channel_id) REFERENCES channel (id)
      )
    ''');
  }

  Future<void> insertProduct(SKU.Data product) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'categories',
        {'id': product.category!.id, 'name': product.category!.name},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.insert(
        'products',
        {
          'id': product.id,
          'sku': product.sku,
          'category_id': product.category!.id,
          'price': product.price ?? 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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

      result.add({
        'id': product['id'],
        'sku': product['sku'],
        'category': category.first,
        'price': product['price'],
        // 'channel_av3m': channelAv3m,
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
    await db.insert('knowledge',
        {'id': knowledge.id, 'path_pdf': knowledge.pathPdf, 'path_video': knowledge.pathVideo},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllKnowledge() async {
    final db = await database;
    return await db.query('knowledge');
  }

  Future<void> insertSurveyQuestion(Survey.SurveyQuestion question) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'survey_questions',
        {
          'id': question.id,
          'title': question.title,
          'name': question.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (question.surveys != null) {
        for (var survey in question.surveys!) {
          await txn.insert(
            'surveys',
            {
              'id': survey.id,
              'product_id': survey.productId,
              'type': survey.type,
              'question': survey.question,
              'survey_question_id': question.id,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAllSurveyQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> questions = await db.query('survey_questions');
    final List<Map<String, dynamic>> result = [];

    for (var questionMap in questions) {
      final surveys = await db.query(
        'surveys',
        where: 'survey_question_id = ?',
        whereArgs: [questionMap['id']],
      );

      result.add({
        'id': questionMap['id'],
        'title': questionMap['title'],
        'name': questionMap['name'],
        'surveys': surveys // Return full list of surveys
      });
    }

    return result;
  }

  // Add method to insert POSM type
  Future<void> insertPosmType(Posm.Data posmType) async {
    final db = await database;
    await db.insert(
      'posm_types',
      posmType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Add method to get all POSM types
  Future<List<Map<String, dynamic>>> getAllPosmTypes() async {
    final db = await database;
    return await db.query('posm_types');
  }

  // Visual type methods
  Future<void> insertVisualType(Visual.Data visualType) async {
    final db = await database;
    await db.insert(
      'visual_types',
      visualType.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllVisualTypes() async {
    final db = await database;
    return await db.query('visual_types');
  }

  Future<void> insertOrUpdatePlanogram(Planogram.Data planogram) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'planograms',
        {
          'channel_id': planogram.channelId,
          'path': planogram.path,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<Map<String, dynamic>>> getPlanogramByChannel(String channelId) async {
    final db = await database;
    print("Starting database query for channelId: $channelId");

    try {
      // First check if the channel exists
      final channelExists = await db.query(
        'channel',
        where: 'id = ?',
        whereArgs: [channelId],
      );
      print("Channel exists: ${channelExists.isNotEmpty}");

      // Then get planograms
      final List<Map<String, dynamic>> results = await db.query(
        'planograms',
        where: 'channel_id = ?',
        whereArgs: [channelId],
      );
      print("Raw query results: $results");

      final mappedResults = results
          .map((row) => {
                'path': row['path'],
              })
          .toList();
      print("Mapped results: $mappedResults");

      return mappedResults;
    } catch (e) {
      print("Database error: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllPlanograms() async {
    final db = await database;
    return await db.query('planograms', columns: ['channel_id', 'path']);
  }
}
