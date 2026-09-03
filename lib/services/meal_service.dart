import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealService {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse(
      '$baseUrl/search.php?s=$query',
    );

    final response = await http.get(url);

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

  Future<Meal?> getMealById(String id) async {
    final url = Uri.parse(
      '$baseUrl/lookup.php?i=$id',
    );

    final response = await http.get(url);

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
}