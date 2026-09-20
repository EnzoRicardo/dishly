import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/meal.dart';
import 'meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  final http.Client _client;

  MealRepositoryImpl({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> _fetchMealsPayload(Uri url, String errorMessage) async {
    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return responseJson['meals'];
    }
    throw Exception(errorMessage);
  }

  @override
  Future<List<Meal>> searchMeals([String query = '']) async {
    final url = Uri.parse(
      '$baseUrl/search.php?s=${Uri.encodeQueryComponent(query.trim())}',
    );
    final mealsJson = await _fetchMealsPayload(url, 'Erro ao buscar pratos');
    if (mealsJson == null) {
      return [];
    }

    return (mealsJson as List)
        .map((mealJson) => Meal.fromJson(mealJson))
        .toList();
  }

  @override
  Future<Meal?> getMealById(String id) async {
    final url = Uri.parse('$baseUrl/lookup.php?i=$id');
    final mealsJson =
        await _fetchMealsPayload(url, 'Erro ao buscar detalhes do prato');

    if (mealsJson == null || (mealsJson as List).isEmpty) {
      return null;
    }

    return Meal.fromJson(mealsJson[0]);
  }
}

