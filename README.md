# Tetris

A modern implementation of the classic Tetris game using Flutter, featuring a retro-style UI and smooth gameplay.

## Latest Updates

### v1.1: Enhanced Visual Effects
- Added block vibration animation (subtle movement in X and Y axes)
- Added color shimmer effect for all tetris blocks
- Improved visual feedback for active and placed blocks
- Fixed scaling issues for different window sizes

## Features

- Classic Tetris gameplay with modern controls
- Retro-style pixel art graphics
- Hold piece functionality
- Next pieces preview (shows next 3 pieces)
- Score tracking
- Line clearing
- Game statistics (lines cleared, time played)
- Pause functionality
- Visual effects:
  - Block vibration animation
  - Color shimmer/pulsing effect
  - Retro-style block borders

## Controls

- **Left Arrow**: Move piece left
- **Right Arrow**: Move piece right
- **Up Arrow**: Rotate piece clockwise
- **Down Arrow**: Move piece down faster
- **Space**: Hard drop (instantly drop piece)
- **C**: Hold current piece
- **Esc**: Pause/Unpause game
- **Space** (when game over): Restart game

## Scoring System

- 1 line cleared: 100 points
- 2 lines cleared: 300 points
- 3 lines cleared: 500 points
- 4 lines cleared: 800 points

## Development

This game is built with Flutter and follows modern development practices:

- State management using Provider
- Clean architecture separating game logic from UI
- Pixel-perfect retro-style graphics
- Smooth animations and controls
- Custom animation effects for enhanced visual feedback

### Requirements

- Flutter SDK
- Dart SDK
- macOS (for running on desktop)

### Running the Game

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the game:
   ```bash
   flutter run -d macos
   ```

## Implementation Details

The game is structured into several key components:

- `GameState`: Manages the game's state and logic
- `Tetromino`: Represents each Tetris piece with its rotations
- `GameBoard`: Renders the main game grid
- `PreviewPanel`: Shows the hold and next pieces
- `ScorePanel`: Displays game statistics
- `AnimatedTetrisBlock`: Handles block animations and effects

The implementation includes features like:
- Wall kicks for piece rotation
- Block animations with shimmer and vibration effects
- Adaptive UI scaling
- Ghost piece preview (coming soon)
- Increasing difficulty over time (coming soon)
- High score tracking (coming soon)

## Animation Details

### Block Vibration
Each tetris block has a subtle vibration animation:
- X-axis movement: ±2 pixels with easeInOutSine curve
- Y-axis movement: ±1 pixel with easeInOutCubic curve
- Animation duration: 1.5 seconds, repeating

### Color Shimmer
Blocks feature a color shimmer effect:
- Lightness increase: 30%
- Saturation increase: 20%
- Slight hue shift: 15 degrees
- Smooth transition using easeInOutSine curve
- Applied to both active and placed blocks

## Future Improvements

- [ ] Add ghost piece preview
- [ ] Implement difficulty progression
- [ ] Add high score system
- [ ] Add sound effects
- [ ] Add animations for line clearing
- [ ] Add touch controls for mobile
- [ ] Add multiplayer support
