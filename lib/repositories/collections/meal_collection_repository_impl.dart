import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/storage_keys.dart';
import '../../models/meal.dart';
import 'meal_collection_repository.dart';

class MealCollectionRepositoryImpl implements MealCollectionRepository {
  final String storageKey;
  final SharedPreferences? prefs;

  MealCollectionRepositoryImpl({
    required this.storageKey,
    this.prefs,
  });

  Future<SharedPreferences> get _asyncPrefs async =>
      prefs ?? await SharedPreferences.getInstance();

  String _userStorageKey(SharedPreferences preferences) {
    final currentUser = preferences.getString(StorageKeys.currentUser);
    return StorageKeys.userCollectionKey(currentUser, storageKey);
  }

  Future<Map<String, dynamic>> _getCollectionMap([SharedPreferences? prefs]) async {
    final preferences = prefs ?? await _asyncPrefs;
    final jsonString = preferences.getString(_userStorageKey(preferences));
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
  Future<List<Meal>> getMeals() async {
    final collectionById = await _getCollectionMap();
    return collectionById.values
        .map((mealJson) => Meal.fromJson(Map<String, dynamic>.from(mealJson)))
        .toList();
  }

  @override
  Future<bool> contains(String id) async {
    final collectionById = await _getCollectionMap();
    return collectionById.containsKey(id);
  }

  @override
  Future<void> toggle(Meal meal) async {
    final prefs = await _asyncPrefs;
    final collectionById = await _getCollectionMap(prefs);

    if (collectionById.containsKey(meal.id)) {
      collectionById.remove(meal.id);
    } else {
      collectionById[meal.id] = meal.toJson();
    }

    await prefs.setString(_userStorageKey(prefs), jsonEncode(collectionById));
  }
}
