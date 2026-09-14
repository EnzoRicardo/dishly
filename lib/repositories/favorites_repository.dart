import '../models/meal.dart';

abstract class FavoritesRepository {
  Future<List<Meal>> getFavorites();
  Future<bool> isFavorite(String id);
  Future<void> toggleFavorite(Meal meal);
}

