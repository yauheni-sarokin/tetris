import 'package:flutter/foundation.dart';

/// Модель для хранения и управления настройками анимации
class AnimationSettings extends ChangeNotifier {
  // Настройки вибрации
  bool _isVibrationEnabled = true;
  double _vibrationSpeed = 1.0; // 0.5 - 2.0
  double _vibrationAmplitude = 2.0; // 1.0 - 10.0

  // Настройки переливания цвета
  bool _isShimmerEnabled = true;
  double _shimmerSpeed = 1.0; // 1.0 - 5.0 секунд
  double _shimmerIntensity = 0.3; // 0.0 - 1.0

  // Настройки тестового режима
  bool _isTestModeEnabled = false;

  // Настройки анимации очистки линии
  static const double defaultLineClearDuration = 0.5; // секунды
  static const int defaultSparkCount = 10; // количество искр на блок

  double _lineClearDuration = 0.3; // Default duration in seconds

  // Геттеры для вибрации
  bool get isVibrationEnabled => _isVibrationEnabled;
  double get vibrationSpeed => _vibrationSpeed;
  double get vibrationAmplitude => _vibrationAmplitude;

  // Геттеры для переливания
  bool get isShimmerEnabled => _isShimmerEnabled;
  double get shimmerSpeed => _shimmerSpeed;
  double get shimmerIntensity => _shimmerIntensity;

  // Геттер для тестового режима
  bool get isTestModeEnabled => _isTestModeEnabled;

  double get lineClearDuration => _lineClearDuration;

  // Сеттеры для вибрации
  void setVibrationEnabled(bool value) {
    if (_isVibrationEnabled != value) {
      _isVibrationEnabled = value;
      notifyListeners();
    }
  }

  void setVibrationSpeed(double value) {
    if (_vibrationSpeed != value) {
      _vibrationSpeed = value;
      notifyListeners();
    }
  }

  void setVibrationAmplitude(double value) {
    if (_vibrationAmplitude != value) {
      _vibrationAmplitude = value;
      notifyListeners();
    }
  }

  // Сеттеры для переливания
  void setShimmerEnabled(bool value) {
    if (_isShimmerEnabled != value) {
      _isShimmerEnabled = value;
      notifyListeners();
    }
  }

  void setShimmerSpeed(double value) {
    if (_shimmerSpeed != value) {
      _shimmerSpeed = value;
      notifyListeners();
    }
  }

  void setShimmerIntensity(double value) {
    if (_shimmerIntensity != value) {
      _shimmerIntensity = value;
      notifyListeners();
    }
  }

  // Сеттер для тестового режима
  void setTestModeEnabled(bool value) {
    if (_isTestModeEnabled != value) {
      _isTestModeEnabled = value;
      notifyListeners();
    }
  }

  void set lineClearDuration(double value) {
    if (value != _lineClearDuration) {
      _lineClearDuration = value;
      notifyListeners();
    }
  }

  // Получить длительность анимации в миллисекундах
  int getAnimationDuration() {
    return (1500 / vibrationSpeed).round();
  }

  // Получить амплитуду вибрации по X
  double getVibrationX() {
    return isVibrationEnabled ? vibrationAmplitude : 0.0;
  }

  // Получить амплитуду вибрации по Y
  double getVibrationY() {
    return isVibrationEnabled ? vibrationAmplitude / 2 : 0.0;
  }

  // Получить интенсивность эффекта переливания
  double getShimmerLightnessIncrease() {
    return isShimmerEnabled ? shimmerIntensity * 0.5 : 0.0;
  }

  // Получить насыщенность эффекта переливания
  double getShimmerSaturationIncrease() {
    return isShimmerEnabled ? shimmerIntensity * 0.3 : 0.0;
  }
}
