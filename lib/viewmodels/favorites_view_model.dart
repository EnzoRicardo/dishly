import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../repositories/favorites_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository _favoritesRepository;

  List<Meal> _favorites = [];
  bool _isLoading = false;
  ImageSize _selectedSize = ImageSize.defaultSize;
  String _searchQuery = '';

  FavoritesViewModel(this._favoritesRepository);

  List<Meal> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isEmpty => _favorites.isEmpty;
  ImageSize get selectedSize => _selectedSize;
  String get searchQuery => _searchQuery;

  List<Meal> get displayedFavorites {
    if (_searchQuery.isEmpty) {
      return _favorites;
    }
    final lower = _searchQuery.toLowerCase();
    return _favorites
        .where((meal) =>
            meal.name.toLowerCase().contains(lower) ||
            (meal.category?.toLowerCase().contains(lower) ?? false) ||
            (meal.area?.toLowerCase().contains(lower) ?? false))
        .toList();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    _favorites = await _favoritesRepository.getFavorites();
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

  Future<void> removeFavorite(Meal meal) async {
    await _favoritesRepository.toggleFavorite(meal);
    _favorites.removeWhere((item) => item.id == meal.id);
    notifyListeners();
  }
}

