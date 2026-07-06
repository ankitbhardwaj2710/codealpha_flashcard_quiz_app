import 'package:flutter/material.dart';

import '../services/score_service.dart';

class ScoreProvider extends ChangeNotifier {
  final ScoreService _scoreService = ScoreService();

  List<Map<String, dynamic>> _scores = [];

  bool _isLoading = false;

  double _highestScore = 0;

  int _totalAttempts = 0;

  Map<String, dynamic>? _latestScore;

  List<Map<String, dynamic>> get scores => _scores;

  bool get isLoading => _isLoading;

  double get highestScore => _highestScore;

  int get totalAttempts => _totalAttempts;

  Map<String, dynamic>? get latestScore => _latestScore;

  Future<void> loadScores() async {
    _isLoading = true;
    notifyListeners();

    _scores = await _scoreService.getAllScores();

    _latestScore = await _scoreService.getLatestScore();

    _highestScore = await _scoreService.getHighestScore();

    _totalAttempts = await _scoreService.getTotalAttempts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveScore({
    required int correct,
    required int wrong,
  }) async {
    await _scoreService.saveScore(
      correct: correct,
      wrong: wrong,
    );

    await loadScores();
  }

  Future<void> clearScores() async {
    await _scoreService.clearScores();

    await loadScores();
  }
}