import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class ScorePanel extends StatelessWidget {
  const ScorePanel({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.white24, width: 2.0),
      ),
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatItem('LINES', gameState.lines.toString()),
              const SizedBox(height: 16),
              _buildStatItem('TIME', _formatDuration(gameState.gameTime)),
              const SizedBox(height: 16),
              _buildStatItem('SCORE', gameState.score.toString()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(color: Colors.white24, width: 1.0),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
