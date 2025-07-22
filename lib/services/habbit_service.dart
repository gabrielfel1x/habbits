import '../core/api_service.dart';
import '../models/habbit.dart';

class HabbitService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createHabbit({
    required String title,
    required String icon,
    required bool sunday,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
  }) async {
    final data = {
      'title': title,
      'icon': icon,
      'sunday': sunday,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
    };
    final response = await _apiService.post('/habits', data);
    return Map<String, dynamic>.from(response);
  }

  Future<List<Habbit>> getAllHabbits() async {
    final response = await _apiService.get('/habits');

    if (response is List) {
      return response.map((json) => Habbit.fromJson(json)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> deleteHabbit(int id) async {
    final response = await _apiService.delete('/habits/$id');
    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateHabbit({
    required int id,
    required String title,
    required String icon,
    required bool sunday,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
  }) async {
    final data = {
      'title': title,
      'icon': icon,
      'sunday': sunday,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
    };
    final response = await _apiService.put('/habits/$id', data);
    return Map<String, dynamic>.from(response);
  }
}
