import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'tetromino.dart';
import 'package:provider/provider.dart';
import 'animation_settings.dart';

class Position {
  int x;
  int y;
  Position(this.x, this.y);
}

class GameState extends ChangeNotifier {
  static const int rows = 20;
  static const int cols = 10;
  static const int nextPiecesCount = 3;

  List<List<Color?>> board;
  Tetromino? currentPiece;
  Position? currentPiecePosition;
  Tetromino? holdPiece;
  bool canHold = true;
  List<Tetromino> nextPieces;
  bool isGameOver = false;
  bool isPaused = false;
  int score = 0;
  int lines = 0;
  DateTime? gameStartTime;
  Timer? gameTimer;
  Duration gameTime = Duration.zero;
  bool isAnimatingLineClear = false;

  // Callback для анимации очистки линии
  VoidCallback? onLineCleared;

  final Random _random = Random();

  GameState()
      : board = List.generate(rows, (_) => List.filled(cols, null)),
        nextPieces = [] {
    _initializeGame();
  }

  Tetromino _generatePiece() {
    final settings = Provider.of<AnimationSettings>(
        navigatorKey.currentContext!,
        listen: false);

    // В тестовом режиме возвращаем только квадратные фигуры
    if (settings.isTestModeEnabled) {
      return Tetromino.fromType(TetrominoType.O);
    }

    return Tetromino.fromType(
      TetrominoType.values[_random.nextInt(TetrominoType.values.length)],
    );
  }

  void _initializeGame() {
    board = List.generate(rows, (_) => List.filled(cols, null));
    nextPieces = List.generate(nextPiecesCount, (_) => _generatePiece());
    gameStartTime = DateTime.now();
    _spawnNewPiece();
    _startTimer();
  }

  void _startTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && !isGameOver) {
        gameTime = DateTime.now().difference(gameStartTime!);
        notifyListeners();
      }
    });
  }

  void _spawnNewPiece() {
    if (currentPiece != null) return;

    currentPiece = nextPieces.removeAt(0);
    nextPieces.add(_generatePiece());

    currentPiecePosition = Position(cols ~/ 2 - 2, 0);

    if (_isColliding()) {
      isGameOver = true;
      gameTimer?.cancel();
    }

    notifyListeners();
  }

  bool _isColliding() {
    if (currentPiece == null || currentPiecePosition == null) return false;

    final shape = currentPiece!.currentShape;
    for (var y = 0; y < shape.length; y++) {
      for (var x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 0) continue;

        final boardX = x + currentPiecePosition!.x;
        final boardY = y + currentPiecePosition!.y;

        if (boardX < 0 || boardX >= cols || boardY >= rows) return true;
        if (boardY >= 0 && board[boardY][boardX] != null) return true;
      }
    }
    return false;
  }

  void moveLeft() {
    if (isGameOver || isPaused) return;
    if (currentPiece == null || currentPiecePosition == null) return;

    currentPiecePosition!.x--;
    if (_isColliding()) {
      currentPiecePosition!.x++;
    } else {
      notifyListeners();
    }
  }

  void moveRight() {
    if (isGameOver || isPaused) return;
    if (currentPiece == null || currentPiecePosition == null) return;

    currentPiecePosition!.x++;
    if (_isColliding()) {
      currentPiecePosition!.x--;
    } else {
      notifyListeners();
    }
  }

  void rotate() {
    if (isGameOver || isPaused) return;
    if (currentPiece == null) return;

    final originalRotation = currentPiece!.currentRotation;
    currentPiece!.rotate();

    if (_isColliding()) {
      // Try wall kicks
      final originalX = currentPiecePosition!.x;

      // Try moving right
      currentPiecePosition!.x++;
      if (!_isColliding()) {
        notifyListeners();
        return;
      }

      // Try moving left
      currentPiecePosition!.x = originalX - 1;
      if (!_isColliding()) {
        notifyListeners();
        return;
      }

      // If all wall kicks fail, revert rotation
      currentPiecePosition!.x = originalX;
      currentPiece!.currentRotation = originalRotation;
    } else {
      notifyListeners();
    }
  }

  void hardDrop() {
    if (isGameOver || isPaused) return;
    if (currentPiece == null || currentPiecePosition == null) return;

    while (!_isColliding()) {
      currentPiecePosition!.y++;
    }
    currentPiecePosition!.y--;
    _lockPiece();
  }

  void moveDown() {
    if (isGameOver || isPaused) return;
    if (currentPiece == null || currentPiecePosition == null) return;

    currentPiecePosition!.y++;
    if (_isColliding()) {
      currentPiecePosition!.y--;
      _lockPiece();
    } else {
      notifyListeners();
    }
  }

  void _clearLines() {
    var linesToClear = <int>[];

    // Находим все заполненные линии (сверху вниз)
    for (var y = 0; y < rows; y++) {
      if (board[y].every((cell) => cell != null)) {
        linesToClear.add(y);
      }
    }

    if (linesToClear.isNotEmpty) {
      isAnimatingLineClear = true;

      // Запускаем анимацию для каждой линии
      if (onLineCleared != null) {
        onLineCleared!();
      }

      final settings = Provider.of<AnimationSettings>(
          navigatorKey.currentContext!,
          listen: false);
      final animationDuration = (settings.lineClearDuration * 1000).round();

      // Задержка перед удалением линий (после анимации)
      Future.delayed(Duration(milliseconds: animationDuration), () {
        // Сортируем линии сверху вниз
        linesToClear.sort();

        // Удаляем линии и сдвигаем оставшиеся вниз
        for (var lineIndex in linesToClear) {
          // Сдвигаем все линии выше удаляемой вниз на одну позицию
          for (var y = lineIndex; y > 0; y--) {
            board[y] = List.from(board[y - 1]);
          }
          // Добавляем пустую линию сверху
          board[0] = List.filled(cols, null);
        }

        lines += linesToClear.length;
        // Score calculation based on number of lines cleared at once
        score += switch (linesToClear.length) {
          1 => 100,
          2 => 300,
          3 => 500,
          4 => 800,
          _ => 0,
        };

        isAnimatingLineClear = false;
        currentPiece = null;
        canHold = true;
        _spawnNewPiece();
        notifyListeners();
      });
    } else {
      currentPiece = null;
      canHold = true;
      _spawnNewPiece();
    }
  }

  void _lockPiece() {
    if (currentPiece == null || currentPiecePosition == null) return;

    final shape = currentPiece!.currentShape;
    for (var y = 0; y < shape.length; y++) {
      for (var x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 0) continue;

        final boardX = x + currentPiecePosition!.x;
        final boardY = y + currentPiecePosition!.y;

        if (boardY >= 0 && boardY < rows && boardX >= 0 && boardX < cols) {
          board[boardY][boardX] = currentPiece!.color;
        }
      }
    }

    _clearLines();
  }

  void swapHoldPiece() {
    if (!canHold || currentPiece == null || isGameOver || isPaused) return;

    final tempHoldPiece = holdPiece;
    holdPiece = Tetromino.fromType(currentPiece!.type);

    if (tempHoldPiece != null) {
      currentPiece = tempHoldPiece;
      currentPiecePosition = Position(cols ~/ 2 - 2, 0);
    } else {
      currentPiece = null;
      _spawnNewPiece();
    }

    canHold = false;
    notifyListeners();
  }

  void togglePause() {
    isPaused = !isPaused;
    notifyListeners();
  }

  void restart() {
    isGameOver = false;
    isPaused = false;
    score = 0;
    lines = 0;
    holdPiece = null;
    canHold = true;
    gameTime = Duration.zero;
    _initializeGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }
}

// Глобальный ключ для доступа к контексту
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
