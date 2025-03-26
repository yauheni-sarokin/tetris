import 'dart:ui';

/// Represents a Tetris piece type
enum TetrominoType { I, O, T, S, Z, J, L }

/// Represents a Tetris piece with its shape and color
class Tetromino {
  final TetrominoType type;
  final Color color;
  final List<List<List<int>>> rotations;
  int currentRotation;

  Tetromino({
    required this.type,
    required this.color,
    required this.rotations,
    this.currentRotation = 0,
  });

  List<List<int>> get currentShape => rotations[currentRotation];

  void rotate() {
    currentRotation = (currentRotation + 1) % rotations.length;
  }

  void rotateBack() {
    currentRotation = (currentRotation - 1) % rotations.length;
  }

  static final Map<TetrominoType, Color> colors = {
    TetrominoType.I: const Color(0xFF00F0F0), // Cyan
    TetrominoType.O: const Color(0xFFF0F000), // Yellow
    TetrominoType.T: const Color(0xFFA000F0), // Purple
    TetrominoType.S: const Color(0xFF00F000), // Green
    TetrominoType.Z: const Color(0xFFF00000), // Red
    TetrominoType.J: const Color(0xFF0000F0), // Blue
    TetrominoType.L: const Color(0xFFF0A000), // Orange
  };

  static final Map<TetrominoType, List<List<List<int>>>> shapes = {
    TetrominoType.I: [
      [
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      [
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
      ],
    ],
    TetrominoType.O: [
      [
        [1, 1],
        [1, 1],
      ],
    ],
    TetrominoType.T: [
      [
        [0, 1, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 1, 0],
      ],
      [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
    TetrominoType.S: [
      [
        [0, 1, 1],
        [1, 1, 0],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 0, 1],
      ],
    ],
    TetrominoType.Z: [
      [
        [1, 1, 0],
        [0, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 0, 1],
        [0, 1, 1],
        [0, 1, 0],
      ],
    ],
    TetrominoType.J: [
      [
        [1, 0, 0],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 1],
        [0, 1, 0],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 1],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 0],
      ],
    ],
    TetrominoType.L: [
      [
        [0, 0, 1],
        [1, 1, 1],
        [0, 0, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [1, 0, 0],
      ],
      [
        [1, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
    ],
  };

  factory Tetromino.fromType(TetrominoType type) {
    return Tetromino(
      type: type,
      color: colors[type]!,
      rotations: shapes[type]!,
    );
  }
}
