# Tetris

A modern implementation of the classic Tetris game using Flutter, featuring a retro-style UI and smooth gameplay.

## Latest Updates

### v1.3: Line Clear Animation and Test Mode
- Added spectacular line clear animation:
  - Blocks explode with particle effects
  - Chain reaction animation from random block
  - Customizable animation duration (0.5 seconds)
- Added Test Mode in settings:
  - Only square blocks spawn when enabled
  - Perfect for testing game mechanics
- Fixed system sound on key press
- Improved settings menu organization

### v1.2: Customizable Animation Settings
- Added settings menu (accessible via Command + , or menu)
- Implemented customizable block vibration settings:
  - Toggle vibration animation on/off
  - Adjust vibration speed (0.5x - 2.0x)
  - Control vibration amplitude (1-10 pixels)
- Added color shimmer customization:
  - Toggle shimmer effect on/off
  - Adjust shimmer animation speed (1-5 seconds)
  - Control shimmer intensity (0-100%)
- Added native macOS menu bar integration

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
- Line clearing with particle effects
- Game statistics (lines cleared, time played)
- Pause functionality
- Visual effects:
  - Customizable block vibration animation
  - Adjustable color shimmer/pulsing effect
  - Spectacular line clear animation
  - Retro-style block borders
- Settings menu with animation customization
- Test mode for debugging

## Controls

- **Left Arrow**: Move piece left
- **Right Arrow**: Move piece right
- **Up Arrow**: Rotate piece clockwise
- **Down Arrow**: Move piece down faster
- **Space**: Hard drop (instantly drop piece)
- **C**: Hold current piece
- **Esc**: Pause/Unpause game
- **Space** (when game over): Restart game
- **Command + ,**: Open settings
- **Command + Q**: Quit game (macOS)

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
- Native macOS integration

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
- `AnimationSettings`: Manages customizable animation parameters
- `SettingsDialog`: Provides UI for animation customization
- `LineClearAnimation`: Handles line clearing effects

The implementation includes features like:
- Wall kicks for piece rotation
- Customizable block animations with shimmer and vibration effects
- Spectacular line clear animations with particle effects
- Adaptive UI scaling
- Native macOS menu integration
- Test mode for debugging
- Ghost piece preview (coming soon)
- Increasing difficulty over time (coming soon)
- High score tracking (coming soon)

## Animation Details

### Block Vibration
Each tetris block has a customizable vibration animation:
- Enable/disable via settings
- Adjustable speed (0.5x - 2.0x)
- Configurable amplitude (1-10 pixels)
- X-axis and Y-axis movement with easeInOutSine curve
- Default settings:
  - Speed: 1.0x
  - Amplitude: 2 pixels

### Color Shimmer
Blocks feature a customizable color shimmer effect:
- Enable/disable via settings
- Adjustable animation speed (1-5 seconds)
- Configurable intensity (0-100%)
- Smooth transition using easeInOutSine curve
- Applied to both active and placed blocks
- Default settings:
  - Speed: 1.0x
  - Intensity: 30%

### Line Clear Animation
When a line is completed, it triggers a spectacular animation:
- Blocks start vibrating and explode
- Particle effects emanate from a random starting block
- Chain reaction spreads to adjacent blocks
- Customizable animation duration (0.5 seconds)
- Smooth transitions and particle physics

## Settings Menu

The game includes a settings menu accessible via:
- Command + , keyboard shortcut
- Tetris menu -> Settings (macOS)

Settings include:
1. Test Mode
   - Enable/disable toggle for spawning only square blocks
2. Block Vibration
   - Enable/disable toggle
   - Speed slider (0.5x - 2.0x)
   - Amplitude slider (1-10 pixels)
3. Color Shimmer
   - Enable/disable toggle
   - Speed slider (1-5 seconds)
   - Intensity slider (0-100%)

All settings are applied in real-time and persist during gameplay.

## Future Improvements

- [ ] Add ghost piece preview
- [ ] Implement difficulty progression
- [ ] Add high score system
- [ ] Add sound effects
- [ ] Add more line clear animation variations
- [ ] Add touch controls for mobile
- [ ] Add multiplayer support
- [ ] Add settings persistence between sessions
- [ ] Add more customization options
