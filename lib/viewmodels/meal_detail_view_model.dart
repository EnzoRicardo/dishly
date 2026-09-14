import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/meal_repository.dart';

class MealDetailViewModel extends ChangeNotifier {
  final MealRepository _repository;
  MealDetailViewModel(this._repository, this._favoritesRepository);
  final FavoritesRepository _favoritesRepository;


  Meal? _meal;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;

  Meal? get meal => _meal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;

  Future<void> loadMealById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _meal = await _repository.getMealById(id);
      _isFavorite = await _favoritesRepository.isFavorite(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os detalhes.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    if (_meal == null) return;
    await _favoritesRepository.toggleFavorite(_meal!);
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}