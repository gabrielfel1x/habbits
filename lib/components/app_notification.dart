import 'package:flutter/material.dart';
import 'package:habbits/core/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNotification extends StatefulWidget {
  final String message;
  final bool isError;
  final VoidCallback? onClose;
  final Duration duration;
  final bool autoClose;

  const AppNotification({
    super.key,
    required this.message,
    this.isError = false,
    this.onClose,
    this.duration = const Duration(seconds: 4),
    this.autoClose = true,
  });

  @override
  State<AppNotification> createState() => _AppNotificationState();
}

class _AppNotificationState extends State<AppNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controlador para animação de slide
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Controlador para animação de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Animação de slide (entrada de cima)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Animação de fade
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Animação de escala
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animações
    _slideController.forward();
    _fadeController.forward();

    // Auto close se habilitado
    if (widget.autoClose) {
      Future.delayed(widget.duration, () {
        if (mounted) {
          _closeNotification();
        }
      });
    }
  }

  void _closeNotification() async {
    // Animação de saída
    await _fadeController.reverse();
    await _slideController.reverse();
    
    if (mounted) {
      widget.onClose?.call();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              decoration: BoxDecoration(
                color: widget.isError
                    ? AppColors.warningColor
                    : (ModalRoute.of(context)?.settings.name == '/register'
                          ? AppColors.secondaryColor
                          : AppColors.primaryColor),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ícone com animação de rotação sutil
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: SvgPicture.asset(
                            widget.isError
                                ? 'assets/rabbit_white.svg'
                                : (ModalRoute.of(context)?.settings.name == '/register'
                                      ? 'assets/rabbit.svg'
                                      : 'assets/rabbit_white.svg'),
                            width: 32,
                            height: 32,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    
                    // Texto com animação de fade
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          color: widget.isError
                              ? AppColors.white
                              : (ModalRoute.of(context)?.settings.name == '/register'
                                    ? Colors.black
                                    : AppColors.white),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        child: Text(widget.message),
                      ),
                    ),
                    
                    // Botão de fechar com animação de hover
                    GestureDetector(
                      onTap: _closeNotification,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            Icons.close,
                            color: widget.isError
                                ? AppColors.white
                                : (ModalRoute.of(context)?.settings.name == '/register'
                                      ? Colors.black
                                      : AppColors.white),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper para mostrar notificações com animação
class NotificationHelper {
  static void showNotification(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 4),
    bool autoClose = true,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 0,
        right: 0,
        child: AppNotification(
          message: message,
          isError: isError,
          duration: duration,
          autoClose: autoClose,
          onClose: () => overlayEntry.remove(),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
  }
}
