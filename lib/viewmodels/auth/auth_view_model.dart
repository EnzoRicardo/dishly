import 'package:flutter/foundation.dart';
import 'package:dishly/repositories/auth/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  String? _currentUser;
  bool _isCheckingSession = true;
  bool _isLoading = false;
  String? _usernameErrorMessage;
  String? _passwordErrorMessage;
  String? _errorMessage;

  AuthViewModel(this._authRepository);

  String? get currentUser => _currentUser;
  bool get isCheckingSession => _isCheckingSession;
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
      final success = await _authRepository.authenticate(user, password);
      if (success) {
        _currentUser = user;
      } else {
        _errorMessage = 'Senha incorreta para o usuário informado.';
      }
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
    _errorMessage = null;
    _usernameErrorMessage = null;
    _passwordErrorMessage = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    try {
      _currentUser = await _authRepository.getUser();
    } catch (e) {
      _errorMessage = 'Falha ao recuperar a sessão: $e';
    } finally {
      _isCheckingSession = false;
      notifyListeners();
    }
  }
}
