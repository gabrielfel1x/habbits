import 'package:flutter/material.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/services/habit_check_service.dart';

class HabitItem {
  final int id;
  final int habitId;
  final String title;
  final IconData icon;
  final bool isCompleted;

  HabitItem({
    required this.id,
    required this.habitId,
    required this.title,
    required this.icon,
    required this.isCompleted,
  });
}

class DailyHabitsList extends StatelessWidget {
  final List<HabitItem> habits;
  final Function(int habitCheckId, bool isCompleted)? onHabitToggle;
  final VoidCallback? onHabitTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const DailyHabitsList({
    super.key,
    required this.habits,
    this.onHabitToggle,
    this.onHabitTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          const Text(
            'Hábitos de hoje',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Clique no hábito para visualizá-lo',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray,
            ),
          ),
          const SizedBox(height: 16),
          
          // Lista de hábitos
          Column(
            children: habits.map((habit) => _buildHabitItem(habit)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitItem(HabitItem habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: habit.isCompleted ? AppColors.secondaryColor : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: habit.isCompleted ? AppColors.primaryColor : AppColors.gray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onHabitTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Ícone do hábito
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: habit.isCompleted 
                        ? AppColors.white.withOpacity(0.3)
                        : AppColors.gray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    habit.icon,
                    color: habit.isCompleted ? AppColors.white : AppColors.black,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Título do hábito
                Expanded(
                  child: Text(
                    habit.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: habit.isCompleted ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
                
                // Checkbox
                GestureDetector(
                  onTap: () => onHabitToggle?.call(habit.id, !habit.isCompleted),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: habit.isCompleted ? AppColors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: habit.isCompleted ? AppColors.white : AppColors.gray,
                        width: 2,
                      ),
                    ),
                    child: habit.isCompleted
                        ? const Icon(
                            Icons.check,
                            color: AppColors.primaryColor,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Componente que busca dados reais da API
class DailyHabitsFromAPI extends StatefulWidget {
  final Function(int habitCheckId, bool isCompleted)? onHabitToggle;
  final VoidCallback? onHabitTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const DailyHabitsFromAPI({
    super.key,
    this.onHabitToggle,
    this.onHabitTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  State<DailyHabitsFromAPI> createState() => _DailyHabitsFromAPIState();
}

class _DailyHabitsFromAPIState extends State<DailyHabitsFromAPI> {
  final HabitCheckService _habitCheckService = HabitCheckService();
  List<HabitItem> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final habitChecks = await _habitCheckService.getTodayHabitChecks();
      final processedHabits = _habitCheckService.processHabitsForList(habitChecks);
      
      if (mounted) {
        setState(() {
          _habits = processedHabits.map((habit) {
            return HabitItem(
              id: habit['id'],
              habitId: habit['habitId'],
              title: habit['title'],
              icon: _getIconFromName(habit['icon']),
              isCompleted: habit['isCompleted'],
            );
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _habits = [];
          _isLoading = false;
        });
      }
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'folha':
        return Icons.eco;
      case 'cama':
        return Icons.bed;
      case 'maçã':
        return Icons.apple;
      case 'café':
        return Icons.local_drink;
      case 'halter':
        return Icons.fitness_center;
      case 'coração':
        return Icons.favorite;
      case 'livro aberto':
        return Icons.menu_book;
      default:
        return Icons.check_circle;
    }
  }

  Future<void> _toggleHabit(int habitCheckId, bool isCompleted) async {
    try {
      await _habitCheckService.toggleHabitCheck(habitCheckId);
      
      // Atualizar estado local
      setState(() {
        final index = _habits.indexWhere((habit) => habit.id == habitCheckId);
        if (index != -1) {
          _habits[index] = HabitItem(
            id: _habits[index].id,
            habitId: _habits[index].habitId,
            title: _habits[index].title,
            icon: _habits[index].icon,
            isCompleted: isCompleted,
          );
        }
      });
      
      // Chamar callback se fornecido
      widget.onHabitToggle?.call(habitCheckId, isCompleted);
    } catch (e) {
      // Mostrar erro para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar hábito: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: widget.margin,
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hábitos de hoje',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Clique no hábito para visualizá-lo',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    // Se não há hábitos, mostrar mensagem bonita
    if (_habits.isEmpty) {
      return Container(
        margin: widget.margin,
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hábitos de hoje',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Clique no hábito para visualizá-lo',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray,
              ),
            ),
            const SizedBox(height: 32),
            
            // Mensagem bonita quando não há hábitos
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.celebration,
                      size: 40,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum hábito para hoje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Que tal criar seu primeiro hábito?\nToque no ícone "+" para começar!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '🚀 Comece sua jornada de hábitos hoje!',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return DailyHabitsList(
      habits: _habits,
      onHabitToggle: _toggleHabit,
      onHabitTap: widget.onHabitTap,
      margin: widget.margin,
      padding: widget.padding,
    );
  }
} 