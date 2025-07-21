import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habbits/core/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconButton(
            icon: LucideIcons.home,
            index: 0,
            selected: currentIndex == 0,
            onTap: onTap,
          ),
          _buildIconButton(
            icon: null,
            svgAsset: currentIndex == 1
                ? 'assets/rabbit_white.svg'
                : 'assets/rabbit_gray.svg',
            index: 1,
            selected: currentIndex == 1,
            onTap: onTap,
            isCenter: true,
          ),
          _buildIconButton(
            icon: LucideIcons.plus,
            index: 2,
            selected: currentIndex == 2,
            onTap: onTap,
          ),
          _buildIconButton(
            icon: LucideIcons.barChart2,
            index: 3,
            selected: currentIndex == 3,
            onTap: onTap,
          ),
          _buildIconButton(
            icon: LucideIcons.user,
            index: 4,
            selected: currentIndex == 4,
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    IconData? icon,
    String? svgAsset,
    required int index,
    required bool selected,
    required ValueChanged<int> onTap,
    bool isCenter = false,
  }) {
    final Color iconColor = selected ? Colors.white : AppColors.grayLight;
    final Widget iconWidget = svgAsset != null
        ? SvgPicture.asset(svgAsset, width: 26, height: 26)
        : Icon(icon, size: 26, color: iconColor);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: selected ? 54.0 : null,
        height: selected ? 54.0 : null,
        decoration: selected
            ? BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        padding: EdgeInsets.all(selected ? 12 : 8),
        child: iconWidget,
      ),
    );
  }
}
