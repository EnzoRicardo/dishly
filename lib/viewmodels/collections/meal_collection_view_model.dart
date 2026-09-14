import 'package:flutter/foundation.dart';

import '../../models/meal.dart';
import '../../repositories/collections/meal_collection_repository.dart';

class MealCollectionViewModel extends ChangeNotifier {
  final MealCollectionRepository repository;

  List<Meal> _meals = [];
  bool _isLoading = false;
  ImageSize _selectedSize = ImageSize.defaultSize;
  String _searchQuery = '';

  MealCollectionViewModel(this.repository);

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  bool get isEmpty => _meals.isEmpty;
  ImageSize get selectedSize => _selectedSize;
  String get searchQuery => _searchQuery;

  List<Meal> get displayedMeals {
    if (_searchQuery.isEmpty) {
      return _meals;
    }
    final lower = _searchQuery.toLowerCase();
    return _meals
        .where((meal) =>
            meal.name.toLowerCase().contains(lower) ||
            (meal.category?.toLowerCase().contains(lower) ?? false) ||
            (meal.area?.toLowerCase().contains(lower) ?? false))
        .toList();
  }

  Future<void> loadMeals() async {
    _isLoading = true;
    notifyListeners();

    _meals = await repository.getMeals();
    _isLoading = false;
    notifyListeners();
  }

  void setSelectedSize(ImageSize size) {
    if (_selectedSize != size) {
      _selectedSize = size;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  Future<void> remove(Meal meal) async {
    await repository.toggle(meal);
    _meals.removeWhere((item) => item.id == meal.id);
    notifyListeners();
  }
}

