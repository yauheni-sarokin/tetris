import 'package:flutter/material.dart';
import '../models/tetromino.dart';
import 'tetris_block.dart';

class PreviewPanel extends StatelessWidget {
  final String title;
  final Tetromino? piece;
  final double size;

  const PreviewPanel({
    super.key,
    required this.title,
    required this.piece,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.white24, width: 2.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 1.0),
              ),
              child:
                  piece == null
                      ? const SizedBox()
                      : LayoutBuilder(
                        builder: (context, constraints) {
                          final shape = piece!.currentShape;
                          final blockSize = constraints.maxWidth / 4;

                          return Center(
                            child: SizedBox(
                              width: blockSize * shape[0].length,
                              height: blockSize * shape.length,
                              child: Stack(
                                children: [
                                  for (var y = 0; y < shape.length; y++)
                                    for (var x = 0; x < shape[y].length; x++)
                                      if (shape[y][x] == 1)
                                        Positioned(
                                          left: x * blockSize,
                                          top: y * blockSize,
                                          width: blockSize,
                                          height: blockSize,
                                          child: TetrisBlock(
                                            color: piece!.color,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
