import 'package:flutter/material.dart';
import '../core/colors.dart';

class IconPicker extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, dynamic>> iconList;
  final IconData? selectedIcon;
  final ValueChanged<IconData> onIconSelected;
  const IconPicker({
    super.key,
    required this.searchController,
    required this.iconList,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Escolha um ícone',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquise um ícone...',
                  hintStyle: TextStyle(fontSize: 12),
                  suffixIcon: Icon(
                    Icons.search,
                    size: 16,
                    color: AppColors.gray,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.gray),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 12),
                enabled: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: iconList.length,
          itemBuilder: (context, i) {
            final icon = iconList[i]['icon'] as IconData;
            final selected = selectedIcon == icon;
            return GestureDetector(
              onTap: () => onIconSelected(icon),
              child: Container(
                width: 24,
                height: 24,
                decoration: selected
                    ? BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      )
                    : null,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? Colors.white : AppColors.black,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
