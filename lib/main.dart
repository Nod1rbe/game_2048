import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/suika_game.dart';
import 'ui/game_ui.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _GamePage(),
    );
  }
}

class _GamePage extends StatefulWidget {
  const _GamePage();
  @override
  State<_GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<_GamePage> {
  late final SuikaGame _game;

  @override
  void initState() {
    super.initState();
    _game = SuikaGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0D),
      body: GameWidget<SuikaGame>(
        game: _game,
        overlayBuilderMap: {'ui': (context, g) => GameUI(game: g)},
        initialActiveOverlays: const ['ui'],
      ),
    );
  }
}
