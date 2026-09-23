import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';
import 'sample_data.dart';

/// Central app state. Holds the list of flashcards in memory, persists
/// changes to SharedPreferences (as JSON) and notifies listeners so every
/// screen (list, quiz, home stats) stays in sync automatically.
class FlashcardStore extends ChangeNotifier {
  static const _prefsKey = 'tribhasha_flashcards_v1';
  List<Flashcard> _cards = [];
  bool loaded = false;

  List<Flashcard> get cards => _cards;

  List<Flashcard> byCategory(String category) =>
      _cards.where((c) => c.category == category).toList();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) {
      _cards = sampleFlashcards();
      await _save();
    } else {
      final List decoded = jsonDecode(raw);
      _cards = decoded.map((e) => Flashcard.fromJson(e)).toList();
    }
    loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_cards.map((c) => c.toJson()).toList());
    await prefs.setString(_prefsKey, raw);
  }

  Future<void> add(Flashcard card) async {
    _cards.add(card);
    notifyListeners();
    await _save();
  }

  Future<void> update(Flashcard card) async {
    final index = _cards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      _cards[index] = card;
      notifyListeners();
      await _save();
    }
  }

  Future<void> delete(String id) async {
    _cards.removeWhere((c) => c.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> toggleFavorite(String id) async {
    final card = _cards.firstWhere((c) => c.id == id);
    card.isFavorite = !card.isFavorite;
    notifyListeners();
    await _save();
  }

  Future<void> recordReview(String id, bool wasCorrect) async {
    final card = _cards.firstWhere((c) => c.id == id);
    card.timesReviewed += 1;
    if (wasCorrect) card.timesCorrect += 1;
    notifyListeners();
    await _save();
  }

  Future<void> resetStats() async {
    for (final card in _cards) {
      card.timesReviewed = 0;
      card.timesCorrect = 0;
    }
    notifyListeners();
    await _save();
  }

  int get totalCards => _cards.length;
  double get overallAccuracy {
    final reviewed = _cards.where((c) => c.timesReviewed > 0).toList();
    if (reviewed.isEmpty) return 0;
    final sum = reviewed.fold<double>(0, (p, c) => p + c.accuracy);
    return sum / reviewed.length;
  }
}
