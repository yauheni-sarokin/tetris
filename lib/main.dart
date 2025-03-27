import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/animation_settings.dart';
import 'models/game_state.dart';
import 'widgets/app_menu.dart';
import 'screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Отключаем системные звуки для игровых клавиш
  HardwareKeyboard.instance.addHandler((KeyEvent event) {
    // Список клавиш, для которых нужно подавить звук
    final keysToSuppress = {
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.space,
      LogicalKeyboardKey.escape,
      LogicalKeyboardKey.keyC,
    };

    if (keysToSuppress.contains(event.logicalKey)) {
      return true; // Подавляем системный звук
    }
    return false; // Для остальных клавиш оставляем стандартное поведение
  });

  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnimationSettings()),
        ChangeNotifierProvider(create: (_) => GameState()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Tetris',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppMenu(
          child: GameScreen(),
        ),
      ),
    );
  }
}
