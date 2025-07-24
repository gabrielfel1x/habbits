import 'package:flutter/material.dart';
import 'package:habbits/components/habit_card.dart';
import 'package:habbits/components/custom_action_button.dart';
import 'package:habbits/services/habbit_service.dart';
import 'package:habbits/models/habbit.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/core/icons_list.dart';
import 'package:habbits/components/app_header.dart';
import 'package:habbits/components/app_bottom_navigation_bar.dart';
import 'package:habbits/components/app_notification.dart';
import 'package:habbits/pages/edit_habit_page.dart';
import 'package:habbits/pages/create_habit_page.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyHabitsPage extends StatefulWidget {
  final VoidCallback? onAddHabit;
  const MyHabitsPage({super.key, this.onAddHabit});

  @override
  State<MyHabitsPage> createState() => _MyHabitsPageState();
}

class _MyHabitsPageState extends State<MyHabitsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Habbit> _habits = [];
  List<Habbit> _filteredHabits = [];
  bool _isLoading = true;
  Widget? _notification;

  @override
  void initState() {
    super.initState();
    _fetchHabits();
    _searchController.addListener(_filterHabits);
  }

  Future<void> _fetchHabits() async {
    setState(() => _isLoading = true);
    try {
      final habits = await HabbitService().getAllHabbits();
      setState(() {
        _habits = habits.cast<Habbit>();
        _filteredHabits = _habits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _habits = [];
        _filteredHabits = [];
        _isLoading = false;
      });
    }
  }

  void _filterHabits() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHabits = _habits;
      } else {
        _filteredHabits = _habits
            .where((h) => h.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  IconData _getIcon(String iconStr) {
    final found = lucideIconList.firstWhere(
      (item) => item['icon'].toString() == iconStr,
      orElse: () => {'icon': Icons.laptop},
    );
    return found['icon'] as IconData;
  }

  void _onEdit(Habbit habit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditHabitPage(habitId: habit.id)),
    );
    _fetchHabits();
  }

  void _showNotification(String message, {bool isError = false}) {
    setState(() {
      _notification = AppNotification(
        message: message,
        isError: isError,
        onClose: () => setState(() => _notification = null),
      );
    });
  }

  void _onDelete(Habbit habit) async {
    setState(() => _isLoading = true);
    try {
      await HabbitService().deleteHabbit(habit.id);
      await _fetchHabits();
      _showNotification('Hábito excluído com sucesso!');
    } catch (e) {
      setState(() => _isLoading = false);
      _showNotification('Erro ao excluir hábito!', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppHeader(
                  title: 'Seus Hábitos',
                  subtitle: 'Gerencie seus hábitos',
                  iconAsset: 'assets/rabbit.svg',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 230,
                      height: 39,
                      child: CustomActionButton(
                        text: 'ADICIONAR',
                        icon: LucideIcons.plus,
                        onPressed:
                            widget.onAddHabit ??
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateHabitPage(),
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Busque pelo nome',
                      suffixIcon: Icon(Icons.search, color: AppColors.gray),
                      filled: true,
                      fillColor: AppColors.grayVeryLight,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredHabits.isEmpty
                      ? const Center(child: Text('Nenhum hábito encontrado'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          itemCount: _filteredHabits.length,
                          itemBuilder: (context, i) {
                            final habit = _filteredHabits[i];
                            final lucide = lucideIconList.firstWhere(
                              (item) =>
                                  item['label'] == habit.icon ||
                                  (item['icon'].toString() == habit.icon) ||
                                  (item['emoji'] != null &&
                                      item['emoji'] == habit.icon),
                              orElse: () => {'icon': Icons.laptop},
                            );
                            return HabitCard(
                              title: habit.title,
                              icon: lucide['icon'] as IconData,
                              onEdit: () => _onEdit(habit),
                              onDelete: () => _onDelete(habit),
                            );
                          },
                        ),
                ),
              ],
            ),
            if (_notification != null)
              Positioned(top: 40, left: 0, right: 0, child: _notification!),
          ],
        ),
      ),
    );
  }
}
