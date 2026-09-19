import 'meal_collection_view_model.dart';

/// Subtipo existe para o Provider distinguir esta coleção da de favoritos.
class CookedMealsViewModel extends MealCollectionViewModel {
  CookedMealsViewModel(super.repository);
}
