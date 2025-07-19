import 'package:flutter/material.dart';
import 'package:habbits/core/colors.dart';

class AuthLinks extends StatelessWidget {
  final String questionText;
  final String linkText;
  final VoidCallback onTap;
  final Color? questionColor;
  final Color? linkColor;

  const AuthLinks({
    super.key,
    required this.questionText,
    required this.linkText,
    required this.onTap,
    this.questionColor = AppColors.gray,
    this.linkColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            questionText,
            style: TextStyle(fontSize: 16, color: questionColor),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                linkText,
                style: TextStyle(
                  fontSize: 16,
                  color: linkColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 