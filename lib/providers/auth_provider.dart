import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:habbits/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  User? _currentUser;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  // Verificar status de autenticação ao inicializar
  Future<void> _checkAuthStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      final userMap = await _authService.getCurrentUser();
      _currentUser = userMap != null ? User.fromMap(userMap) : null;
    }
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.login(email, password);
      _isLoggedIn = true;
      final userMap = await _authService.getCurrentUser();
      _currentUser = userMap != null ? User.fromMap(userMap) : null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Registro
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.register(name, email, password);
      _isLoggedIn = true;
      final userMap = await _authService.getCurrentUser();
      _currentUser = userMap != null ? User.fromMap(userMap) : null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    if (error.startsWith('Exception: ')) {
      _error = error.replaceFirst('Exception: ', '');
    } else {
      _error = error;
    }
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
