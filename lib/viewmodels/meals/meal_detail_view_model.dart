import 'package:flutter/foundation.dart';

import '../../models/collection_type.dart';
import '../../models/meal.dart';
import '../../repositories/collections/meal_collection_repository.dart';
import '../../repositories/meals/meal_repository.dart';

class MealDetailViewModel extends ChangeNotifier {
  final MealRepository _repository;
  final Map<CollectionType, MealCollectionRepository> _collectionRepositories;

  MealDetailViewModel(
    this._repository,
    this._collectionRepositories,
  );

  Meal? _meal;
  bool _isLoading = false;
  String? _errorMessage;
  final Map<CollectionType, bool> _collectionStatus = {};

  Meal? get meal => _meal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isInCollection(CollectionType type) => _collectionStatus[type] ?? false;

  Future<void> loadMealById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _meal = await _repository.getMealById(id);
      for (final entry in _collectionRepositories.entries) {
        _collectionStatus[entry.key] = await entry.value.contains(id);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os detalhes.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCollection(CollectionType type) async {
    final meal = _meal;
    final repo = _collectionRepositories[type];
    if (meal == null || repo == null) return;

    await repo.toggle(meal);
    _collectionStatus[type] = !isInCollection(type);
    notifyListeners();
  }
}