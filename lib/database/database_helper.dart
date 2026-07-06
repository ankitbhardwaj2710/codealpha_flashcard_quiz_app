import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'flashcard_quiz.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Flashcards Table
    await db.execute('''
      CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Categories Table
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    // Scores Table
    await db.execute('''
      CREATE TABLE scores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correct INTEGER NOT NULL,
        wrong INTEGER NOT NULL,
        percentage REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Default Categories
    await db.insert('categories', {'name': 'General'});
    await db.insert('categories', {'name': 'Programming'});
    await db.insert('categories', {'name': 'Science'});
    await db.insert('categories', {'name': 'Mathematics'});
    await db.insert('categories', {'name': 'English'});
  }

  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
  }
}