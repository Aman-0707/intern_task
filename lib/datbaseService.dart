import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'articlesfull.db');
    print('Database Path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
         CREATE TABLE articlesfull (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         title TEXT,
         imageData BLOB,
         link TEXT,
         date TEXT,
         description TEXT
);
        ''');
      },
    );
  }

  Future<int> insertArticle(Map<String, dynamic> article) async {
    final db = await database;

    // Check if an article with the same title already exists
    final result = await db.query(
      'articlesfull',
      where: 'title = ?',
      whereArgs: [article['title']],
    );

    if (result.isNotEmpty) {
      // If the article already exists, don't insert it
      print('Article with title "${article['title']}" already exists.');
      return 0; // Return 0 to indicate no insert happened
    } else {
      // If the article doesn't exist, insert it
      return await db.insert('articlesfull', article);
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllArticles() async {
    final db = await DatabaseHelper().database;
    return await db.query(
      'articlesfull',
      orderBy: 'date DESC',
    );
  }

  // Insert or update the description for a specific article
  Future<void> insertDescription(String title, String description) async {
    final db = await database;
    await db.update(
      'articlesfull',
      {'description': description},
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  // Get the description for a specific article
  Future<String?> getDescription(String title) async {
    final db = await database;
    final result = await db.query(
      'articlesfull',
      columns: ['description'],
      where: 'title = ?',
      whereArgs: [title],
    );
    if (result.isNotEmpty) {
      return result.first['description'] as String?;
    }
    return null;
  }
}
