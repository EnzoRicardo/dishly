import '../../constants/storage_keys.dart';
import 'cooked_meals_repository.dart';
import 'meal_collection_repository_impl.dart';

class CookedMealsRepositoryImpl extends MealCollectionRepositoryImpl
    implements CookedMealsRepository {
  CookedMealsRepositoryImpl({super.prefs})
      : super(storageKey: StorageKeys.cookedMeals);
}
