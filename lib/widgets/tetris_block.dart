import 'package:flutter/material.dart';

class TetrisBlock extends StatelessWidget {
  final Color? color;
  final bool isGhost;

  const TetrisBlock({super.key, required this.color, this.isGhost = false});

  @override
  Widget build(BuildContext context) {
    if (color == null) return const SizedBox.expand();

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isGhost ? color!.withOpacity(0.2) : color,
        border: Border(
          top: BorderSide(color: color!.withOpacity(0.8), width: 2),
          left: BorderSide(color: color!.withOpacity(0.8), width: 2),
          right: BorderSide(color: color!.withOpacity(0.3), width: 2),
          bottom: BorderSide(color: color!.withOpacity(0.3), width: 2),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }
}
