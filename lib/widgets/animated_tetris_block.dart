import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animation_settings.dart';

/// Виджет для отображения анимированного блока тетриса с эффектами вибрации и переливания цвета
class AnimatedTetrisBlock extends StatefulWidget {
  final Color? color;
  final bool isActive;

  const AnimatedTetrisBlock({
    super.key,
    required this.color,
    this.isActive = false,
  });

  @override
  State<AnimatedTetrisBlock> createState() => _AnimatedTetrisBlockState();
}

class _AnimatedTetrisBlockState extends State<AnimatedTetrisBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;
  late Animation<Offset> _vibrationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _shimmerAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );

    _vibrationAnimation = _controller.drive(
      TweenSequence<Offset>([
        TweenSequenceItem(
          tween: Tween<Offset>(
            begin: const Offset(0, 0),
            end: const Offset(1, 0.5),
          ).chain(CurveTween(curve: Curves.easeInOutSine)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween<Offset>(
            begin: const Offset(1, 0.5),
            end: const Offset(-1, -0.5),
          ).chain(CurveTween(curve: Curves.easeInOutSine)),
          weight: 2,
        ),
        TweenSequenceItem(
          tween: Tween<Offset>(
            begin: const Offset(-1, -0.5),
            end: const Offset(0, 0),
          ).chain(CurveTween(curve: Curves.easeInOutSine)),
          weight: 1,
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == null) {
      return const SizedBox.expand();
    }

    return Consumer<AnimationSettings>(
      builder: (context, settings, _) {
        // Обновляем длительность анимации
        _controller.duration = Duration(
          milliseconds: settings.getAnimationDuration(),
        );

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final HSLColor hslColor = HSLColor.fromColor(widget.color!);
            final double shimmerValue = _shimmerAnimation.value;

            // Применяем настройки шиммера
            final Color shimmerColor = settings.isShimmerEnabled
                ? hslColor
                    .withLightness(
                      (hslColor.lightness +
                              shimmerValue *
                                  settings.getShimmerLightnessIncrease())
                          .clamp(0.0, 1.0),
                    )
                    .withSaturation(
                      (hslColor.saturation +
                              shimmerValue *
                                  settings.getShimmerSaturationIncrease())
                          .clamp(0.0, 1.0),
                    )
                    .toColor()
                : widget.color!;

            // Применяем настройки вибрации
            final double dx =
                settings.getVibrationX() * _vibrationAnimation.value.dx;
            final double dy =
                settings.getVibrationY() * _vibrationAnimation.value.dy;

            return Transform.translate(
              offset: Offset(dx, dy),
              child: Container(
                decoration: BoxDecoration(
                  color: shimmerColor,
                  border: Border.all(
                    color: shimmerColor.withOpacity(0.7),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
