import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/preview_panel.dart';
import '../widgets/score_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _dropTimer;
  static const _initialDropInterval = Duration(milliseconds: 800);
  Duration _currentDropInterval = _initialDropInterval;

  @override
  void initState() {
    super.initState();
    _startDropTimer();
  }

  void _startDropTimer() {
    _dropTimer?.cancel();
    _dropTimer = Timer.periodic(_currentDropInterval, (timer) {
      final gameState = context.read<GameState>();
      if (!gameState.isPaused && !gameState.isGameOver) {
        gameState.moveDown();
      }
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return;

    final gameState = context.read<GameState>();
    if (gameState.isGameOver) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        gameState.restart();
      }
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      gameState.togglePause();
      return;
    }

    if (gameState.isPaused) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        gameState.moveLeft();
      case LogicalKeyboardKey.arrowRight:
        gameState.moveRight();
      case LogicalKeyboardKey.arrowUp:
        gameState.rotate();
      case LogicalKeyboardKey.arrowDown:
        gameState.moveDown();
      case LogicalKeyboardKey.space:
        gameState.hardDrop();
      case LogicalKeyboardKey.keyC:
        gameState.swapHoldPiece();
    }
  }

  @override
  void dispose() {
    _dropTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900.withOpacity(0.3), Colors.black],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate sizes based on available space
                final availableWidth = constraints.maxWidth;
                final availableHeight = constraints.maxHeight;
                final gameHeight = availableHeight;
                final gameWidth =
                    gameHeight * (GameState.cols / GameState.rows);
                final sidePanelWidth = (availableWidth - gameWidth - 32) / 2;

                // Ensure minimum sizes
                final minSidePanelWidth = 120.0;
                final scale =
                    sidePanelWidth >= minSidePanelWidth
                        ? 1.0
                        : sidePanelWidth / minSidePanelWidth;

                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: gameWidth + 2 * minSidePanelWidth + 32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left panel (HOLD)
                          SizedBox(
                            width: minSidePanelWidth,
                            child: Transform.scale(
                              scale: scale,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<GameState>(
                                    builder: (context, gameState, child) {
                                      return PreviewPanel(
                                        title: 'HOLD',
                                        piece: gameState.holdPiece,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Game board
                          SizedBox(
                            width: gameWidth,
                            height: gameHeight,
                            child: const GameBoard(),
                          ),
                          const SizedBox(width: 16),
                          // Right panel (NEXT + Stats)
                          SizedBox(
                            width: minSidePanelWidth,
                            child: Transform.scale(
                              scale: scale,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<GameState>(
                                    builder: (context, gameState, child) {
                                      return Column(
                                        children: [
                                          for (
                                            var i = 0;
                                            i < gameState.nextPieces.length;
                                            i++
                                          )
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                              ),
                                              child: PreviewPanel(
                                                title: i == 0 ? 'NEXT' : '',
                                                piece: gameState.nextPieces[i],
                                                size: i == 0 ? 120 : 80,
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const ScorePanel(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
