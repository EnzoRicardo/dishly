import '../../constants/storage_keys.dart';
import 'favorites_repository.dart';
import 'meal_collection_repository_impl.dart';

class FavoritesRepositoryImpl extends MealCollectionRepositoryImpl
    implements FavoritesRepository {
  FavoritesRepositoryImpl({super.prefs})
      : super(storageKey: StorageKeys.favorites);
}
