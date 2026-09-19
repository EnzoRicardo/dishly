import 'package:flutter/foundation.dart';
import 'package:dishly/repositories/auth/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  String? _currentUser;
  bool _isLoading = false;
  String? _usernameErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;

  AuthViewModel(this._authRepository);

  String? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get usernameErrorMessage => _usernameErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  Future<void> login(String username, String password) async {
    final user = username.trim();

    _usernameErrorMessage = null;
    _passwordErrorMessage = null;
    _errorMessage = null;

    var hasError = false;

    if (user.isEmpty) {
      _usernameErrorMessage = 'Informe um usuário';
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordErrorMessage = 'Informe uma senha';
      hasError = true;
    }

    if (hasError) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.saveUser(user);
      _currentUser = user;
    } catch (e) {
      _errorMessage = 'Falha ao fazer login: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.clearUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    _currentUser = await _authRepository.getUser();
    notifyListeners();
  }
}
