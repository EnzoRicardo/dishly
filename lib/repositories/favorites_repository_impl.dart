import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  static const String _favoritesKey = 'favorite_meals';

  Future<Map<String, dynamic>> _getFavoritesMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (_) {
      return {};
    }
  }

  @override
  Future<List<Meal>> getFavorites() async {
    final favoritesById = await _getFavoritesMap();
    return favoritesById.values
        .map((mealJson) => Meal.fromJson(Map<String, dynamic>.from(mealJson)))
        .toList();
  }

  @override
  Future<bool> isFavorite(String id) async {
    final favoritesById = await _getFavoritesMap();
    return favoritesById.containsKey(id);
  }

  @override
  Future<void> toggleFavorite(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesById = await _getFavoritesMap();

    if (favoritesById.containsKey(meal.id)) {
      favoritesById.remove(meal.id);
    } else {
      favoritesById[meal.id] = meal.toJson();
    }

    await prefs.setString(_favoritesKey, jsonEncode(favoritesById));
  }
}
