abstract class AuthRepository {
  Future<void> saveUser(String username);
  Future<String?> getUser();
  Future<void> clearUser();
  Future<bool> authenticate(String username, String password);
}
