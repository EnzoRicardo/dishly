import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../repositories/meal_repository.dart';

class MealsViewModel extends ChangeNotifier {
  final MealRepository _repository;

  static const int pageSize = 6;
  int _visibleCount = pageSize;

  bool _isLoading = false;
  String? _errorMessage;
  List<Meal> _allMeals = [];
  ImageSize _selectedSize = ImageSize.defaultSize;
  String _currentQuery = '';

  MealsViewModel(this._repository);

  List<Meal> get allMeals => _allMeals;
  List<Meal> get displayedMeals => _allMeals.take(_visibleCount).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ImageSize get selectedSize => _selectedSize;
  String get currentQuery => _currentQuery;
  int get visibleCount => _visibleCount;
  int get totalCount => _allMeals.length;
  int get remainingCount =>
      (_allMeals.length - _visibleCount).clamp(0, _allMeals.length);
  bool get hasMore => remainingCount > 0;

  Future<void> fetchMeals([String query = '']) async {
    _currentQuery = query.trim();
    _isLoading = true;
    _errorMessage = null;
    _visibleCount = pageSize;
    notifyListeners();

    try {
      _allMeals = await _repository.searchMeals(_currentQuery);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os pratos.';
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadMore() {
    if (hasMore) {
      _visibleCount += pageSize;
      notifyListeners();
    }
  }

  void setSelectedSize(ImageSize size) {
    if (_selectedSize != size) {
      _selectedSize = size;
      notifyListeners();
    }
  }

  List<String> getImages([ImageSize? size]) {
    return _repository.getImages(_allMeals, size ?? _selectedSize);
  }
}
