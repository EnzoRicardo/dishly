import 'package:flutter/foundation.dart';

import '../../models/meal.dart';
import '../../repositories/meals/meal_repository.dart';

class MealsViewModel extends ChangeNotifier {
  final MealRepository _repository;
  MealsViewModel(this._repository);

  static const int pageSize = 6;
  int _visibleCount = pageSize;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<Meal> _allMeals = [];
  ImageSize _selectedSize = ImageSize.defaultSize;
  String _currentQuery = '';

  List<Meal> get allMeals => _allMeals;
  List<Meal> get displayedMeals => _allMeals.take(_visibleCount).toList();
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  ImageSize get selectedSize => _selectedSize;
  String get currentQuery => _currentQuery;
  int get visibleCount => _visibleCount;
  int get totalCount => _allMeals.length;
  int get remainingCount =>
      (_allMeals.length - _visibleCount).clamp(0, _allMeals.length);
  bool get hasMore => remainingCount > 0;

  Future<List<Meal>> fetchMeals([String query = '']) async {
    _currentQuery = query.trim();
    _isLoading = true;
    _errorMessage = null;
    _visibleCount = pageSize;
    notifyListeners();

    try {
      _allMeals = await _repository.searchMeals(_currentQuery);
      return _allMeals;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os pratos.';
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || _isLoading || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      _visibleCount += pageSize;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setSelectedSize(ImageSize size) {
    if (_selectedSize != size) {
      _selectedSize = size;
      notifyListeners();
    }
  }
}
