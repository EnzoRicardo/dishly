import '../../models/meal.dart';

abstract class MealCollectionRepository {
  Future<List<Meal>> getMeals();
  Future<bool> contains(String id);
  Future<void> toggle(Meal meal);
}
