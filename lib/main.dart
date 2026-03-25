import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_2048/ui/widgets/home_panel.dart';

import 'game/suika_game.dart';
import 'ui/game_ui.dart';
import 'ui/widgets/common_widgets.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final SuikaGame _game;

  @override
  void initState() {
    super.initState();
    _game = SuikaGame();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePanel(game: _game),
      routes: {
        '/game': (context) => _GameView(game: _game),
      },
    );
  }
}

class _GameView extends StatelessWidget {
  final SuikaGame game;
  const _GameView({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          GameWidget<SuikaGame>(
            game: game,
            overlayBuilderMap: {'ui': (context, g) => GameUI(game: g)},
            initialActiveOverlays: const ['ui'],
          ),
        ],
      ),
    );
  }
}
