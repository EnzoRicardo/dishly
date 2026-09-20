import '../../models/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> searchMeals([String query = '']);
  Future<Meal?> getMealById(String id);
}
