import 'meal_collection_view_model.dart';

class CookedMealsViewModel extends MealCollectionViewModel {
  CookedMealsViewModel(super.repository);

  Future<void> loadCookedMeals() => loadMeals();
}
