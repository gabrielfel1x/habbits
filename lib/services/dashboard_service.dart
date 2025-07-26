import '../core/api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>?> getDashboardData() async {
    try {
      final response = await _apiService.get('/dashboard');
      if (response != null && response['data'] != null) {
        return Map<String, dynamic>.from(response['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
} 