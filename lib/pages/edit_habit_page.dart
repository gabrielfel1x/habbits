import 'package:flutter/material.dart';
import 'package:habbits/components/app_notification.dart';
import 'package:habbits/components/custom_action_button.dart';
import 'package:habbits/components/habit_name_input.dart';
import 'package:habbits/components/icon_picker.dart';
import 'package:habbits/components/week_days_selector.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/core/icons_list.dart';
import 'package:habbits/components/app_header.dart';
import 'package:habbits/services/habbit_service.dart';
import 'package:habbits/models/habbit.dart';

class EditHabitPage extends StatefulWidget {
  final int habitId;
  const EditHabitPage({super.key, required this.habitId});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _iconSearchController = TextEditingController();
  final List<bool> _selectedDays = List.generate(
    7,
    (i) => i == 1 || i == 2 || i == 3 || i == 4 || i == 5,
  );
  List<Map<String, dynamic>> _filteredIconList = [];
  IconData? _selectedLucideIcon;
  Widget? _notification;
  Habbit? _habit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _filteredIconList = List.from(lucideIconList);
    _iconSearchController.addListener(_filterIcons);
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    setState(() => _isLoading = true);
    try {
      final habits = await HabbitService().getAllHabbits();
      Habbit? habit;
      try {
        habit = habits.firstWhere((h) => h.id == widget.habitId);
      } catch (_) {
        habit = null;
      }
      if (habit != null) {
        _habit = habit;
        _titleController.text = habit.title;
        _selectedLucideIcon =
            lucideIconList.firstWhere(
                  (item) =>
                      (habit != null && item['label'] == habit.icon) ||
                      (habit != null &&
                          item['icon'].toString() == habit.icon) ||
                      (habit != null &&
                          item['emoji'] != null &&
                          item['emoji'] == habit.icon),
                  orElse: () => {'icon': lucideIconList[0]['icon']},
                )['icon']
                as IconData;
        _selectedDays[0] = habit.sunday;
        _selectedDays[1] = habit.monday;
        _selectedDays[2] = habit.tuesday;
        _selectedDays[3] = habit.wednesday;
        _selectedDays[4] = habit.thursday;
        _selectedDays[5] = habit.friday;
        _selectedDays[6] = habit.saturday;
      }
    } catch (e) {}
    setState(() => _isLoading = false);
  }

  void _updateHabit() async {
    if (_habit == null) return;
    if (_selectedLucideIcon == null) {
      showNotification('Selecione um ícone!', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final selectedIconLabel =
          lucideIconList.firstWhere(
                (item) => item['icon'] == _selectedLucideIcon,
                orElse: () => {
                  'label': _selectedLucideIcon?.codePoint.toString() ?? '',
                },
              )['label']
              as String;
      await HabbitService().updateHabbit(
        id: _habit!.id,
        title: _titleController.text,
        icon: selectedIconLabel,
        sunday: _selectedDays[0],
        monday: _selectedDays[1],
        tuesday: _selectedDays[2],
        wednesday: _selectedDays[3],
        thursday: _selectedDays[4],
        friday: _selectedDays[5],
        saturday: _selectedDays[6],
      );
      if (!mounted) return;
      showNotification('Hábito atualizado com sucesso!');
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showNotification('Erro ao atualizar hábito', isError: true);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _filterIcons() {
    final query = _iconSearchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIconList = List.from(lucideIconList);
      } else {
        _filteredIconList = lucideIconList.where((item) {
          final label = item['label'] as String;
          return label.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void showNotification(String message, {bool isError = false}) {
    setState(() {
      _notification = AppNotification(
        message: message,
        isError: isError,
        onClose: () => setState(() => _notification = null),
      );
    });
  }

  @override
  void dispose() {
    _iconSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 84),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Voltar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppHeader(
                      title: 'Editar hábito',
                      subtitle: 'Hábito #${widget.habitId}',
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HabitNameInput(controller: _titleController),
                          const SizedBox(height: 24),
                          WeekDaysSelector(
                            selectedDays: _selectedDays,
                            onDayToggle: (i) {
                              setState(
                                () => _selectedDays[i] = !_selectedDays[i],
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          IconPicker(
                            searchController: _iconSearchController,
                            iconList: _filteredIconList,
                            selectedIcon: _selectedLucideIcon,
                            onIconSelected: (icon) {
                              setState(() => _selectedLucideIcon = icon);
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: CustomActionButton(
                  text: 'ATUALIZAR',
                  icon: Icons.arrow_upward_rounded,
                  onPressed: _updateHabit,
                ),
              ),
            ),
            if (_notification != null)
              Positioned(top: 40, left: 0, right: 0, child: _notification!),
          ],
        ),
      ),
    );
  }
}
