import '../core/api_service.dart';

class HabitCheckService {
  final ApiService _apiService = ApiService();

  // Buscar habit checks do dia atual
  Future<List<Map<String, dynamic>>> getTodayHabitChecks() async {
    try {
      final response = await _apiService.get('/habit-checks');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Marcar/desmarcar um hábito como concluído
  Future<Map<String, dynamic>> toggleHabitCheck(int habitCheckId) async {
    try {
      final response = await _apiService.put('/habit-checks/$habitCheckId/check', {});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Processar dados para o componente de progresso
  Map<String, int> calculateProgress(List<Map<String, dynamic>> habitChecks) {
    int total = habitChecks.length;
    int completed = habitChecks.where((check) => check['done'] == true).length;
    
    return {
      'total': total,
      'completed': completed,
    };
  }

  // Processar dados para o componente de lista de hábitos
  List<Map<String, dynamic>> processHabitsForList(List<Map<String, dynamic>> habitChecks) {
    return habitChecks.map((check) {
      final habit = check['Habit'];
      return {
        'id': check['ID'],
        'habitId': habit['ID'],
        'title': habit['title'],
        'icon': habit['icon'],
        'isCompleted': check['done'],
        'date': check['date'],
      };
    }).toList();
  }

  // Mapear ícones da API para ícones do Flutter
  String mapIconToFlutter(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'folha':
        return 'eco';
      case 'cama':
        return 'bed';
      case 'maçã':
        return 'apple';
      case 'café':
        return 'local_drink';
      case 'halter':
        return 'fitness_center';
      case 'coração':
        return 'favorite';
      case 'livro aberto':
        return 'menu_book';
      default:
        return 'check_circle';
    }
  }
} 