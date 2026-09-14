import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../repositories/meal_repository.dart';

class MealDetailViewModel extends ChangeNotifier {
  final MealRepository _repository;
  MealDetailViewModel(this._repository);

  Meal? _meal;
  bool _isLoading = false;
  String? _errorMessage;

  Meal? get meal => _meal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMealById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _meal = await _repository.getMealById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os detalhes.';
      _isLoading = false;
      notifyListeners();
    }
  }
}