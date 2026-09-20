abstract final class StorageKeys {
  static const String currentUser = 'current_user';
  static const String usersDb = 'users_db';
  static const String favorites = 'favorite_meals';
  static const String cookedMeals = 'cooked_meals';

  static String userCollectionKey(String? username, String collectionKey) {
    if (username == null || username.isEmpty) {
      return collectionKey;
    }
    return '${username}_$collectionKey';
  }
}
