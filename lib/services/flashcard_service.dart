import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/flashcard_model.dart';

class FlashcardService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  /// Insert Flashcard
  Future<int> addFlashcard(FlashcardModel flashcard) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'flashcards',
      flashcard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get All Flashcards
  Future<List<FlashcardModel>> getAllFlashcards() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      orderBy: 'createdAt DESC',
    );

    return maps.map((e) => FlashcardModel.fromMap(e)).toList();
  }

  /// Get Flashcards by Category
  Future<List<FlashcardModel>> getFlashcardsByCategory(
    String category,
  ) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'createdAt DESC',
    );

    return maps.map((e) => FlashcardModel.fromMap(e)).toList();
  }

  /// Search Flashcards
  Future<List<FlashcardModel>> searchFlashcards(
    String keyword,
  ) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'question LIKE ? OR answer LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'createdAt DESC',
    );

    return maps.map((e) => FlashcardModel.fromMap(e)).toList();
  }

  /// Update Flashcard
  Future<int> updateFlashcard(FlashcardModel flashcard) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'flashcards',
      flashcard.toMap(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  /// Delete Flashcard
  Future<int> deleteFlashcard(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Total Flashcards
  Future<int> getTotalFlashcards() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM flashcards',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Delete All Flashcards
  Future<void> deleteAllFlashcards() async {
    final Database db = await _databaseHelper.database;

    await db.delete('flashcards');
  }
}