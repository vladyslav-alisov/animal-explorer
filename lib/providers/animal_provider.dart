import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/animal_model.dart';
import '../data/animal_data.dart';

class AnimalProvider with ChangeNotifier {
  final List<Animal> _animals = AnimalData.animals;
  List<Animal> get animals => _animals;

  final Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;

  int _bestQuizScore = 0;
  int get bestQuizScore => _bestQuizScore;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    _favoriteIds.addAll(favorites);

    _bestQuizScore = prefs.getInt('bestQuizScore') ?? 0;

    // Update animals list with favorites
    for (var animal in _animals) {
      animal.isFavorite = _favoriteIds.contains(animal.id);
    }
    notifyListeners();
  }

  void toggleFavorite(String animalId) async {
    if (_favoriteIds.contains(animalId)) {
      _favoriteIds.remove(animalId);
    } else {
      _favoriteIds.add(animalId);
    }

    // Update animal object
    final index = _animals.indexWhere((a) => a.id == animalId);
    if (index != -1) {
      _animals[index].isFavorite = _favoriteIds.contains(animalId);
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds.toList());
  }

  void updateBestScore(int score) async {
    if (score > _bestQuizScore) {
      _bestQuizScore = score;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('bestQuizScore', _bestQuizScore);
    }
  }

  Animal get featuredAnimal {
    // Just pick one based on day or random for now
    return _animals[DateTime.now().day % _animals.length];
  }
}
