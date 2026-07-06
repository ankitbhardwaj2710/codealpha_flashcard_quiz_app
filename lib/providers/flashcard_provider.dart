import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';
import '../services/flashcard_service.dart';

class FlashcardProvider extends ChangeNotifier {
  final FlashcardService _flashcardService = FlashcardService();

  List<FlashcardModel> _flashcards = [];
  bool _isLoading = false;
  String? _selectedCategory;

  List<FlashcardModel> get flashcards => _flashcards;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  /// Load All Flashcards
  Future<void> loadFlashcards() async {
    _isLoading = true;
    notifyListeners();

    _flashcards = await _flashcardService.getAllFlashcards();

    _isLoading = false;
    notifyListeners();
  }

  /// Add Flashcard
  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await _flashcardService.addFlashcard(flashcard);
    await loadFlashcards();
  }

  /// Update Flashcard
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await _flashcardService.updateFlashcard(flashcard);
    await loadFlashcards();
  }

  /// Delete Flashcard
  Future<void> deleteFlashcard(int id) async {
    await _flashcardService.deleteFlashcard(id);
    await loadFlashcards();
  }

  /// Search Flashcards
  Future<void> searchFlashcards(String keyword) async {
    if (keyword.trim().isEmpty) {
      await loadFlashcards();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _flashcards = await _flashcardService.searchFlashcards(keyword);

    _isLoading = false;
    notifyListeners();
  }

  /// Filter by Category
  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;

    _isLoading = true;
    notifyListeners();

    if (category == null || category == 'All') {
      _flashcards = await _flashcardService.getAllFlashcards();
    } else {
      _flashcards =
          await _flashcardService.getFlashcardsByCategory(category);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh
  Future<void> refresh() async {
    await loadFlashcards();
  }

  /// Total Cards
  int get totalCards => _flashcards.length;
}