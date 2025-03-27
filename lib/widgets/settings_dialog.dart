import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animation_settings.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Настройки анимации',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildVibrationSettings(context),
            const SizedBox(height: 16),
            _buildShimmerSettings(context),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Закрыть'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVibrationSettings(BuildContext context) {
    return Consumer<AnimationSettings>(
      builder: (context, settings, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Анимация движения кубиков'),
                const Spacer(),
                Switch(
                  value: settings.isVibrationEnabled,
                  onChanged: settings.setVibrationEnabled,
                ),
              ],
            ),
            if (settings.isVibrationEnabled) ...[
              const SizedBox(height: 8),
              const Text('Скорость анимации'),
              Slider(
                value: settings.vibrationSpeed,
                min: 0.5,
                max: 2.0,
                divisions: 15,
                label: settings.vibrationSpeed.toStringAsFixed(2),
                onChanged: settings.setVibrationSpeed,
              ),
              const Text('Амплитуда движения'),
              Slider(
                value: settings.vibrationAmplitude,
                min: 1.0,
                max: 10.0,
                divisions: 18,
                label: '${settings.vibrationAmplitude.toStringAsFixed(1)} px',
                onChanged: settings.setVibrationAmplitude,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildShimmerSettings(BuildContext context) {
    return Consumer<AnimationSettings>(
      builder: (context, settings, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Анимация перелива цвета'),
                const Spacer(),
                Switch(
                  value: settings.isShimmerEnabled,
                  onChanged: settings.setShimmerEnabled,
                ),
              ],
            ),
            if (settings.isShimmerEnabled) ...[
              const SizedBox(height: 8),
              const Text('Скорость анимации'),
              Slider(
                value: settings.shimmerSpeed,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                label: '${settings.shimmerSpeed.toStringAsFixed(1)} сек',
                onChanged: settings.setShimmerSpeed,
              ),
              const Text('Интенсивность эффекта'),
              Slider(
                value: settings.shimmerIntensity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label:
                    (settings.shimmerIntensity * 100).toStringAsFixed(0) + '%',
                onChanged: settings.setShimmerIntensity,
              ),
            ],
          ],
        );
      },
    );
  }
}
