import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/date_utils.dart';

class WeekDaysSelector extends StatelessWidget {
  final List<bool> selectedDays;
  final ValueChanged<int> onDayToggle;
  const WeekDaysSelector({
    super.key,
    required this.selectedDays,
    required this.onDayToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dias da semana',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 2),
        Text(
          'Selecione os dias que você quer para o hábito',
          style: TextStyle(fontSize: 13, color: AppColors.gray),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(weekDaysShort.length, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ChoiceChip(
                  label: Center(
                    child: Text(
                      weekDaysShort[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedDays[i] ? Colors.white : AppColors.gray,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  selected: selectedDays[i],
                  selectedColor: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  onSelected: (_) => onDayToggle(i),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  showCheckmark: false,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
