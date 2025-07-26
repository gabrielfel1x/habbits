import 'package:flutter/material.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/services/phrase_service.dart';

class QuoteCard extends StatefulWidget {
  final String quote;
  final String author;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? authorColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
    this.backgroundColor,
    this.textColor,
    this.authorColor,
    this.borderColor,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(24.0),
    this.margin = const EdgeInsets.all(16.0),
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _performPulseAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _performPulseAnimation,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: widget.margin,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(widget.borderRadius!),
                border: Border(
                  left: BorderSide(
                    color: widget.borderColor ?? AppColors.primaryColor,
                    width: 6.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.borderColor ?? AppColors.primaryColor)
                        .withOpacity(0.3 * _glowAnimation.value),
                    blurRadius: 20.0 * _glowAnimation.value,
                    spreadRadius: 5.0 * _glowAnimation.value,
                  ),
                ],
              ),
              child: Container(
                padding: widget.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone de aspas com animação
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Icon(
                          Icons.format_quote,
                          size: 32 + (4 * _glowAnimation.value),
                          color: widget.textColor ?? AppColors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Texto da citação
                    Text(
                      '"${widget.quote}"',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: widget.textColor ?? AppColors.white,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Linha separadora e autor alinhados à direita
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 40 + (10 * _glowAnimation.value),
                              height: 2,
                              color: widget.authorColor ?? AppColors.white,
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.author,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: widget.authorColor ?? AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Componente que busca frases da API
class MotivationalQuote extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? authorColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;

  const MotivationalQuote({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.authorColor,
    this.borderColor,
    this.margin = const EdgeInsets.all(16.0),
  });

  @override
  State<MotivationalQuote> createState() => _MotivationalQuoteState();
}

class _MotivationalQuoteState extends State<MotivationalQuote> {
  final PhraseService _phraseService = PhraseService();
  Map<String, dynamic>? _phrase;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomPhrase();
  }

  Future<void> _loadRandomPhrase() async {
    try {
      final phrase = await _phraseService.getRandomPhrase();
      if (mounted) {
        setState(() {
          _phrase = phrase;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _phrase = {
            'quote': 'A persistência é o caminho do êxito.',
            'author': 'Charles Chaplin',
          };
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        margin: widget.margin,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border(
            left: BorderSide(
              color: widget.borderColor ?? AppColors.primaryColor,
              width: 6.0,
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.white,
          ),
        ),
      );
    }

    if (_phrase == null) {
      return const SizedBox.shrink();
    }

    return QuoteCard(
      quote: _phrase!['quote'] ?? '',
      author: _phrase!['author'] ?? '',
      backgroundColor: widget.backgroundColor,
      textColor: widget.textColor,
      authorColor: widget.authorColor,
      borderColor: widget.borderColor,
      margin: widget.margin,
    );
  }
} 