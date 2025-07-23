import 'package:flutter/material.dart';
import 'package:habbits/components/app_header.dart';
import 'package:habbits/components/app_notification.dart';
import 'package:habbits/components/habit_name_input.dart';
import 'package:habbits/components/icon_picker.dart';
import 'package:habbits/components/week_days_selector.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/core/icons_list.dart';
import 'package:habbits/core/date_utils.dart';
import 'package:habbits/services/habbit_service.dart';
import 'package:habbits/main.dart';
import 'package:habbits/components/custom_action_button.dart';

class CreateHabitPage extends StatefulWidget {
  const CreateHabitPage({super.key});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _iconSearchController = TextEditingController();
  final List<bool> _selectedDays = List.generate(7, (_) => false);
  List<Map<String, dynamic>> _filteredIconList = [];
  IconData? _selectedLucideIcon;
  Widget? _notification;

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
  void initState() {
    super.initState();
    _filteredIconList = List.from(lucideIconList);
    _iconSearchController.addListener(_filterIcons);
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
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 84),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const AppHeader(
                    title: 'Criar novo hábito',
                    subtitle: 'Pequenos passos, grandes mudanças',
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
            // Botão CRIAR fixo na base
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: CustomActionButton(
                  text: 'CRIAR',
                  icon: Icons.add,
                  onPressed: () async {
                    final title = _titleController.text.trim();
                    final icon = _selectedLucideIcon != null
                        ? _selectedLucideIcon!.fontFamily
                        : null;
                    if (title.isEmpty ||
                        icon == null ||
                        !_selectedDays.contains(true)) {
                      showNotification(
                        'Preencha todos os campos!',
                        isError: true,
                      );
                      return;
                    }
                    final days = {
                      'sunday': _selectedDays[0],
                      'monday': _selectedDays[1],
                      'tuesday': _selectedDays[2],
                      'wednesday': _selectedDays[3],
                      'thursday': _selectedDays[4],
                      'friday': _selectedDays[5],
                      'saturday': _selectedDays[6],
                    };
                    final habbitService = HabbitService();
                    try {
                      await habbitService.createHabbit(
                        title: title,
                        icon: _selectedLucideIcon != null
                            ? lucideIconList.firstWhere(
                                (item) => item['icon'] == _selectedLucideIcon,
                              )['label']
                            : '',
                        sunday: days['sunday']!,
                        monday: days['monday']!,
                        tuesday: days['tuesday']!,
                        wednesday: days['wednesday']!,
                        thursday: days['thursday']!,
                        friday: days['friday']!,
                        saturday: days['saturday']!,
                      );
                      showNotification('Hábito criado com sucesso!');
                      await Future.delayed(const Duration(seconds: 2));
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => MainNavigationScreen(initialIndex: 1),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      showNotification('Erro ao criar hábito!', isError: true);
                    }
                  },
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
