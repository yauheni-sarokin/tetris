import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'screens/game_screen.dart';
import 'models/animation_settings.dart';
import 'widgets/app_menu.dart';

void main() {
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
        title: 'Tetris',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const AppMenu(child: GameScreen()),
      ),
    );
  }
}
