import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habbits/core/colors.dart';

class AppHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? iconAsset;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconAsset = 'assets/rabbit.svg',
    this.iconSize = 26,
    this.padding,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _performBackflip() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Spacer(),
              if (widget.iconAsset != null)
                GestureDetector(
                  onTap: _performBackflip,
                  child: AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159, // 360 graus em radianos
                        child: SvgPicture.asset(
                          widget.iconAsset!,
                          width: widget.iconSize,
                          height: widget.iconSize,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
