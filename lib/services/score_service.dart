import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class ScoreService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  /// Save Quiz Result
  Future<int> saveScore({
    required int correct,
    required int wrong,
  }) async {
    final Database db = await _databaseHelper.database;

    final int total = correct + wrong;

    final double percentage =
        total == 0 ? 0 : (correct / total) * 100;

    return await db.insert(
      'scores',
      {
        'correct': correct,
        'wrong': wrong,
        'percentage': percentage,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Get Quiz History
  Future<List<Map<String, dynamic>>> getAllScores() async {
    final Database db = await _databaseHelper.database;

    return await db.query(
      'scores',
      orderBy: 'createdAt DESC',
    );
  }

  /// Get Latest Score
  Future<Map<String, dynamic>?> getLatestScore() async {
    final Database db = await _databaseHelper.database;

    final result = await db.query(
      'scores',
      orderBy: 'createdAt DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  /// Highest Percentage
  Future<double> getHighestScore() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT MAX(percentage) as maxScore FROM scores',
    );

    if (result.isEmpty) return 0;

    final value = result.first['maxScore'];

    if (value == null) return 0;

    return (value as num).toDouble();
  }

  /// Total Quiz Attempts
  Future<int> getTotalAttempts() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM scores',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Delete All Scores
  Future<void> clearScores() async {
    final Database db = await _databaseHelper.database;

    await db.delete('scores');
  }
}