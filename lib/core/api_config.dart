class ApiConfig {
  static const String baseUrl = 'http://localhost:3000/api';

  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
} 