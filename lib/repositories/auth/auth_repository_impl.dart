import 'dart:convert';
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

  Map<String, dynamic> _getUsersMap(SharedPreferences preferences) {
    final usersJson = preferences.getString(StorageKeys.usersDb);
    if (usersJson == null || usersJson.isEmpty) {
      return {};
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(usersJson));
    } catch (_) {
      return {};
    }
  }

  @override
  Future<bool> authenticate(String username, String password) async {
    final preferences = await _asyncPrefs;
    final users = _getUsersMap(preferences);

    if (users.containsKey(username)) {
      if (users[username] != password) {
        return false;
      }
    } else {
      users[username] = password;
      await preferences.setString(StorageKeys.usersDb, jsonEncode(users));
    }

    await saveUser(username);
    return true;
  }
}

