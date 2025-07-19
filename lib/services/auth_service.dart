import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_service.dart';
import '../core/api_config.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login do usuário
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(ApiConfig.loginEndpoint, {
        'email': email,
        'password': password,
      });

      // Salvar token no SharedPreferences
      if (response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response['token']);
        await prefs.setString('user_id', response['user']['id'].toString());
        await prefs.setString('user_name', response['user']['name']);
        await prefs.setString('user_email', response['user']['email']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Registro do usuário
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post(ApiConfig.registerEndpoint, {
        'name': name,
        'email': email,
        'password': password,
      });

      // Salvar token no SharedPreferences
      if (response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response['token']);
        await prefs.setString('user_id', response['user']['id'].toString());
        await prefs.setString('user_name', response['user']['name']);
        await prefs.setString('user_email', response['user']['email']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Verificar se o usuário está logado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null;
  }

  // Obter dados do usuário logado
  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null) return null;

    return {
      'id': prefs.getString('user_id') ?? '',
      'name': prefs.getString('user_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
    };
  }
} 