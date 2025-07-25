import 'package:flutter/material.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/services/habit_check_service.dart';

class DailyProgressCard extends StatelessWidget {
  final int completedHabits;
  final int totalHabits;
  final String title;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const DailyProgressCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    this.title = 'Progresso de hoje',
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.padding = const EdgeInsets.symmetric(vertical: 20.0),
  });

  double get progressPercentage {
    if (totalHabits == 0) return 0.0;
    return (completedHabits / totalHabits).clamp(0.0, 1.0);
  }

  String get percentageText {
    return '${(progressPercentage * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e contador
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                '$completedHabits/$totalHabits',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Barra de progresso
          Column(
            children: [
              // Container da barra
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    minHeight: 8,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Porcentagem
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  percentageText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Componente que busca dados reais da API
class DailyProgressFromAPI extends StatefulWidget {
  final String title;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const DailyProgressFromAPI({
    super.key,
    this.title = 'Progresso de hoje',
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.padding = const EdgeInsets.symmetric(vertical: 20.0),
  });

  @override
  State<DailyProgressFromAPI> createState() => DailyProgressFromAPIState();
}

class DailyProgressFromAPIState extends State<DailyProgressFromAPI> {
  final HabitCheckService _habitCheckService = HabitCheckService();
  int _completedHabits = 0;
  int _totalHabits = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDailyProgress();
  }

  Future<void> loadDailyProgress() async {
    try {
      final habitChecks = await _habitCheckService.getTodayHabitChecks();
      final progress = _habitCheckService.calculateProgress(habitChecks);
      
      if (mounted) {
        setState(() {
          _completedHabits = progress['completed']!;
          _totalHabits = progress['total']!;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _completedHabits = 0;
          _totalHabits = 0;
          _isLoading = false;
        });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.gray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return DailyProgressCard(
      completedHabits: _completedHabits,
      totalHabits: _totalHabits,
      title: widget.title,
      margin: widget.margin,
      padding: widget.padding,
    );
  }
} 