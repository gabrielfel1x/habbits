import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double? fontSize;
  final double? iconSize;
  final Color? textColor;
  final MainAxisAlignment alignment;

  const AppLogo({
    super.key,
    this.fontSize = 24,
    this.iconSize = 28,
    this.textColor = Colors.black,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(
          'Habbits',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(width: 10),
        SvgPicture.asset(
          ModalRoute.of(context)?.settings.name == '/register'
              ? 'assets/rabbit_white.svg'
              : 'assets/rabbit.svg',
          width: iconSize,
          height: iconSize,
        ),
      ],
    );
  }
}
