import 'meal_collection_view_model.dart';

class FavoritesViewModel extends MealCollectionViewModel {
  FavoritesViewModel(super.repository);

  Future<void> loadFavorites() => loadMeals();
}
