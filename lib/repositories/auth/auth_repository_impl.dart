import '../../constants/storage_keys.dart';
import '../../repositories/auth/auth_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences? prefs;

  AuthRepositoryImpl({this.prefs});

  Future<SharedPreferences> get _asyncPrefs async =>
      prefs ?? await SharedPreferences.getInstance();

  @override
  Future<void> saveUser(String username) async {
    final preferences = await _asyncPrefs;
    await preferences.setString(StorageKeys.currentUser, username);
  }

  @override
  Future<String?> getUser() async {
    final preferences = await _asyncPrefs;
    return preferences.getString(StorageKeys.currentUser);
  }

  @override
  Future<void> clearUser() async {
    final preferences = await _asyncPrefs;
    await preferences.remove(StorageKeys.currentUser);
  }
}
