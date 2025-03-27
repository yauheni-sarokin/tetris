import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/tetromino.dart';
import 'animated_tetris_block.dart';
import 'line_clear_animation.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final List<int> _animatingLines = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.white24, width: 2.0),
      ),
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          // Регистрируем callback для анимации
          gameState.onLineCleared = () {
            setState(() {
              // Находим линии для анимации
              _animatingLines.clear();
              for (var y = GameState.rows - 1; y >= 0; y--) {
                if (gameState.board[y].every((cell) => cell != null)) {
                  _animatingLines.add(y);
                }
              }
            });
          };

          // Создаем доску для отображения
          final displayBoard = List.generate(
            GameState.rows,
            (y) => List.generate(GameState.cols, (x) {
              // Проверяем, есть ли на этой позиции текущая падающая фигура
              if (gameState.currentPiece != null &&
                  gameState.currentPiecePosition != null) {
                final pieceX = x - gameState.currentPiecePosition!.x;
                final pieceY = y - gameState.currentPiecePosition!.y;

                if (pieceX >= 0 &&
                    pieceX < gameState.currentPiece!.currentShape[0].length &&
                    pieceY >= 0 &&
                    pieceY < gameState.currentPiece!.currentShape.length) {
                  if (gameState.currentPiece!.currentShape[pieceY][pieceX] ==
                      1) {
                    return gameState.currentPiece!.color;
                  }
                }
              }
              return gameState.board[y][x];
            }),
          );

          final cellSize = MediaQuery.of(context).size.width / GameState.cols;

          return Stack(
            children: [
              // Основная сетка
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameState.cols,
                ),
                itemCount: GameState.rows * GameState.cols,
                itemBuilder: (context, index) {
                  final x = index % GameState.cols;
                  final y = index ~/ GameState.cols;
                  final color = displayBoard[y][x];

                  if (color != null) {
                    // Если линия анимируется, не показываем обычный блок
                    if (_animatingLines.contains(y)) {
                      return const SizedBox();
                    }
                    return AnimatedTetrisBlock(color: color);
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white10,
                        width: 0.5,
                      ),
                    ),
                  );
                },
              ),

              // Анимация очистки линий
              if (_animatingLines.isNotEmpty)
                for (var y in _animatingLines)
                  for (var x = 0; x < GameState.cols; x++)
                    if (displayBoard[y][x] != null)
                      Positioned(
                        left: x * cellSize,
                        top: y * cellSize,
                        width: cellSize,
                        height: cellSize,
                        child: LineClearAnimation(
                          blockColor: displayBoard[y][x]!,
                          onAnimationComplete: () {
                            if (mounted) {
                              setState(() {
                                _animatingLines.remove(y);
                              });
                            }
                          },
                          position: Offset(x.toDouble(), y.toDouble()),
                          totalBlocks: GameState.cols,
                        ),
                      ),

              // Game Over overlay
              if (gameState.isGameOver)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Text(
                      'Game Over',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Pause overlay
              if (gameState.isPaused)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Text(
                      'Paused',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
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
