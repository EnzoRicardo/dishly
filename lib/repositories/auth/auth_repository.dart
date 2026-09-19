abstract class AuthRepository {
  Future<void> saveUser(String username);
  Future<String?> getUser();
  Future<void> clearUser();
}
