import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animation_settings.dart';

class LineClearAnimation extends StatefulWidget {
  final Color blockColor;
  final VoidCallback onAnimationComplete;
  final Offset position;
  final int totalBlocks;

  const LineClearAnimation({
    super.key,
    required this.blockColor,
    required this.onAnimationComplete,
    required this.position,
    required this.totalBlocks,
  });

  @override
  State<LineClearAnimation> createState() => _LineClearAnimationState();
}

class _LineClearAnimationState extends State<LineClearAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    final settings = Provider.of<AnimationSettings>(context, listen: false);

    _controller = AnimationController(
      duration:
          Duration(milliseconds: (settings.lineClearDuration * 1000).round()),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().then((_) => widget.onAnimationComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: widget.blockColor,
          border: Border.all(
            color: Colors.white10,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
