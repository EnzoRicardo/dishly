import '../../models/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> searchMeals([String query = '']);
  Future<Meal?> getMealById(String id);
  Future<Meal?> getRandomMeal();
  Future<List<String>> getCategories();
  Future<List<Meal>> getMealsByCategory(String category);
}
