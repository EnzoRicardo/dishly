import 'meal_collection_view_model.dart';

/// Subtipo existe para o Provider distinguir esta coleção da de cozinhados.
class FavoritesViewModel extends MealCollectionViewModel {
  FavoritesViewModel(super.repository);
}
