import 'package:flutter/material.dart';
import '../core/colors.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  const CustomActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, color: AppColors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
