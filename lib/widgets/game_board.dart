import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/tetromino.dart';
import 'tetris_block.dart';

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
                  final x = index % GameState.cols;
                  final y = index ~/ GameState.cols;
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
                  Color? blockColor = gameState.board[y][x];

                  // Draw current piece
                  if (gameState.currentPiece != null &&
                      gameState.currentPiecePosition != null) {
                    final piece = gameState.currentPiece!;
                    final pos = gameState.currentPiecePosition!;
                    final shape = piece.currentShape;

                    final pieceX = x - pos.x;
                    final pieceY = y - pos.y;

                    if (pieceX >= 0 &&
                        pieceX < shape[0].length &&
                        pieceY >= 0 &&
                        pieceY < shape.length) {
                      if (shape[pieceY][pieceX] == 1) {
                        blockColor = piece.color;
                      }
                    }
                  }

                  return TetrisBlock(color: blockColor);
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
