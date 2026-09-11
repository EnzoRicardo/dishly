import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';
import 'meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  final http.Client _client;

  MealRepositoryImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<Meal>> searchMeals([String query = '']) async {
    final url = Uri.parse('$baseUrl/search.php?s=$query');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealsJson = data['meals'];

      if (mealsJson == null) {
        return [];
      }

      return (mealsJson as List)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList();
    }

    throw Exception('Erro ao buscar pratos');
  }

  @override
  Future<Meal?> getMealById(String id) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$id');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealsJson = data['meals'];

      if (mealsJson == null || mealsJson.isEmpty) {
        return null;
      }

      return Meal.fromJson(mealsJson[0]);
    }

    throw Exception('Erro ao buscar detalhes do prato');
  }

  @override
  Future<Meal?> getRandomMeal() async {
    final url = Uri.parse('$baseUrl/random.php');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealsJson = data['meals'];

      if (mealsJson == null || mealsJson.isEmpty) {
        return null;
      }

      return Meal.fromJson(mealsJson[0]);
    }

    throw Exception('Erro ao buscar prato aleatório');
  }

  @override
  Future<List<String>> getCategories() async {
    final url = Uri.parse('$baseUrl/list.php?c=list');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final categoriesJson = data['meals'];

      if (categoriesJson == null) {
        return [];
      }

      return (categoriesJson as List)
          .map((categoryJson) => categoryJson['strCategory'] as String)
          .toList();
    }

    throw Exception('Erro ao buscar categorias de pratos');
  }

  @override
  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse('$baseUrl/filter.php?c=$category');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealsJson = data['meals'];

      if (mealsJson == null) {
        return [];
      }

      return (mealsJson as List)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList();
    }

    throw Exception('Erro ao buscar pratos por categoria');
  }

  @override
  List<String> getImages(List<Meal> meals, [ImageSize size = ImageSize.defaultSize]) {
    return meals
        .map((meal) => meal.getImage(size))
        .where((imageUrl) => imageUrl.isNotEmpty)
        .toList();
  }
}
