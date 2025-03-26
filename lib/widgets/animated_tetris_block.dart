import 'package:flutter/material.dart';

/// Виджет для отображения анимированного блока тетриса с эффектами вибрации и переливания цвета
class AnimatedTetrisBlock extends StatefulWidget {
  final Color? color;
  final bool isGhost;

  const AnimatedTetrisBlock({
    super.key,
    required this.color,
    this.isGhost = false,
  });

  @override
  State<AnimatedTetrisBlock> createState() => _AnimatedTetrisBlockState();
}

class _AnimatedTetrisBlockState extends State<AnimatedTetrisBlock>
    with SingleTickerProviderStateMixin {
  // Контроллер для анимации вибрации и переливания
  late final AnimationController _controller;

  // Анимации для смещения по X и Y
  late final Animation<double> _vibrationX;
  late final Animation<double> _vibrationY;

  // Анимация для переливания цвета
  Animation<Color?>? _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Инициализация контроллера анимации
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Настройка анимации вибрации по X
    _vibrationX = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // Настройка анимации вибрации по Y
    _vibrationY = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // Настройка анимации переливания цвета
    if (widget.color != null) {
      _shimmerAnimation = ColorTween(
        begin: widget.color,
        end: _getShimmerColor(widget.color!),
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
      );
    }
  }

  // Получаем цвет для эффекта переливания на основе базового цвета
  Color _getShimmerColor(Color baseColor) {
    final HSLColor hslColor = HSLColor.fromColor(baseColor);

    // Создаем более яркий и насыщенный цвет для заметного эффекта переливания
    return hslColor
        .withLightness(
          (hslColor.lightness + 0.3).clamp(0.0, 1.0),
        ) // Увеличиваем яркость на 30%
        .withSaturation(
          (hslColor.saturation + 0.2).clamp(0.0, 1.0),
        ) // Увеличиваем насыщенность на 20%
        .withHue((hslColor.hue + 15) % 360) // Слегка смещаем оттенок
        .toColor();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == null) return const SizedBox.expand();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentColor = _shimmerAnimation?.value ?? widget.color;

        return Transform.translate(
          offset: Offset(_vibrationX.value, _vibrationY.value),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color:
                  widget.isGhost
                      ? currentColor?.withOpacity(0.2)
                      : currentColor,
              border: Border(
                top: BorderSide(
                  color: currentColor?.withOpacity(0.8) ?? Colors.transparent,
                  width: 2,
                ),
                left: BorderSide(
                  color: currentColor?.withOpacity(0.8) ?? Colors.transparent,
                  width: 2,
                ),
                right: BorderSide(
                  color: currentColor?.withOpacity(0.3) ?? Colors.transparent,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: currentColor?.withOpacity(0.3) ?? Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
