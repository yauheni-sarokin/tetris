import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/tetromino.dart';
import 'animated_tetris_block.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.white24, width: 2.0),
      ),
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          // Создаем матрицу цветов, включающую и упавшие, и падающие фигуры
          final displayBoard = List.generate(
            GameState.rows,
            (y) => List.generate(GameState.cols, (x) => gameState.board[y][x]),
          );

          // Добавляем текущую падающую фигуру на доску
          if (gameState.currentPiece != null &&
              gameState.currentPiecePosition != null) {
            final piece = gameState.currentPiece!;
            final pos = gameState.currentPiecePosition!;
            final shape = piece.currentShape;

            for (var y = 0; y < shape.length; y++) {
              for (var x = 0; x < shape[y].length; x++) {
                if (shape[y][x] == 1) {
                  final boardX = x + pos.x;
                  final boardY = y + pos.y;
                  if (boardY >= 0 &&
                      boardY < GameState.rows &&
                      boardX >= 0 &&
                      boardX < GameState.cols) {
                    displayBoard[boardY][boardX] = piece.color;
                  }
                }
              }
            }
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameState.cols,
                  childAspectRatio: 1.0,
                ),
                itemCount: GameState.rows * GameState.cols,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 0.5),
                    ),
                  );
                },
              ),
              // Game pieces
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameState.cols,
                  childAspectRatio: 1.0,
                ),
                itemCount: GameState.rows * GameState.cols,
                itemBuilder: (context, index) {
                  final x = index % GameState.cols;
                  final y = index ~/ GameState.cols;
                  final blockColor = displayBoard[y][x];

                  return AnimatedTetrisBlock(
                    color: blockColor,
                    key: ValueKey('block_${y}_${x}_${blockColor?.value}'),
                  );
                },
              ),
              // Game over overlay
              if (gameState.isGameOver)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'GAME OVER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Score: ${gameState.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Press SPACE to restart',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              // Pause overlay
              if (gameState.isPaused)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
