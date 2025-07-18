import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: ApiConfig.defaultHeaders,
      ),
    );

    // Interceptor para adicionar token de autenticação
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (error, handler) {
          // Tratamento de erros global
          if (error.response?.statusCode == 401) {
            // Token expirado ou inválido
            _handleUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
  }

  void _handleUnauthorized() {
    // Implementar logout automático
    // Navigator.pushReplacementNamed(context, '/login');
  }

  // Método genérico para requisições GET
  Future<T> get<T>(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Método genérico para requisições POST
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Método genérico para requisições PUT
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Método genérico para requisições DELETE
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Timeout de conexão. Verifique sua internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        var message;
        if (e.response?.data is String) {
          message = e.response?.data;
          return Exception(message);
        } else if (e.response?.data is Map) {
          if (e.response?.data['error'] != null) {
            message = e.response?.data['error'];
            return Exception(message);
          } else if (e.response?.data['message'] != null) {
            message = e.response?.data['message'];
            return Exception('Erro $statusCode: $message');
          } else {
            message = 'Erro na requisição';
            return Exception('Erro $statusCode: $message');
          }
        } else {
          message = 'Erro na requisição';
          return Exception('Erro $statusCode: $message');
        }
      case DioExceptionType.cancel:
        return Exception('Requisição cancelada');
      default:
        return Exception('Erro de conexão. Verifique sua internet.');
    }
  }
}
