import 'package:flutter/material.dart';
import 'package:habbits/components/app_bottom_navigation_bar.dart';
import 'package:habbits/components/app_header.dart';
import 'package:habbits/components/quote_card.dart';
import 'package:habbits/components/daily_progress_card.dart';
import 'package:habbits/components/daily_habits_list.dart';
import 'package:provider/provider.dart';
import 'package:habbits/providers/auth_provider.dart';
import 'package:habbits/core/date_utils.dart';
import 'package:habbits/core/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DailyProgressFromAPIState> _progressKey = GlobalKey();

  void _onHabitToggle(int habitCheckId, bool isCompleted) {
    print('Hábito $habitCheckId foi ${isCompleted ? 'completado' : 'desmarcado'}');
    
    // Atualizar o progresso quando um hábito for marcado/desmarcado
    _progressKey.currentState?.loadDailyProgress();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    final name = user?.name ?? '';
    final now = DateTime.now();
    final dateStr = formatarData(now);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(title: 'Olá, $name', subtitle: dateStr),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Citação motivacional
                  const MotivationalQuote(
                    margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Progresso diário
                  DailyProgressFromAPI(
                    key: _progressKey,
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Lista de hábitos
                  DailyHabitsFromAPI(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    onHabitToggle: _onHabitToggle,
                    onHabitTap: () {
                      print('Hábito clicado para visualizar');
                      // TODO: Navegar para página de detalhes do hábito
                    },
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
