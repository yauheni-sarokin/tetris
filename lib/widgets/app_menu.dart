import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'settings_dialog.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({super.key, required this.child});

  final Widget child;

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем, что мы на macOS
    if (Platform.isMacOS) {
      return PlatformMenuBar(
        menus: [
          PlatformMenu(
            label: 'Tetris',
            menus: [
              PlatformMenuItemGroup(
                members: [
                  PlatformMenuItem(
                    label: 'О программе',
                    onSelected: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Tetris',
                        applicationVersion: 'v1.1',
                        applicationIcon: const FlutterLogo(size: 32),
                      );
                    },
                  ),
                  PlatformMenuItem(
                    label: 'Настройки',
                    onSelected: () => _showSettings(context),
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.comma,
                      meta: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        child: _buildShortcutsWrapper(context),
      );
    }

    // Для других платформ возвращаем только шорткаты
    return _buildShortcutsWrapper(context);
  }

  Widget _buildShortcutsWrapper(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.comma, meta: true):
            OpenSettingsIntent(),
      },
      child: Actions(
        actions: {
          OpenSettingsIntent: CallbackAction<OpenSettingsIntent>(
            onInvoke: (intent) => _showSettings(context),
          ),
        },
        child: child,
      ),
    );
  }
}

class OpenSettingsIntent extends Intent {
  const OpenSettingsIntent();
}
