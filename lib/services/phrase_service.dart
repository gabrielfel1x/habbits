import '../core/api_service.dart';

class PhraseService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getRandomPhrase() async {
    try {
      final response = await _apiService.get('/phrases/random');
      return response['phrase'];
    } catch (e) {
      return {
        'id': 0,
        'quote': 'A persistência é o caminho do êxito.',
        'author': 'Charles Chaplin',
      };
    }
  }
}
