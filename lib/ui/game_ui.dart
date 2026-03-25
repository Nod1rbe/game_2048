import 'package:flutter/material.dart';
import '../game/suika_game.dart';
import 'widgets/hud_bar.dart';
import 'widgets/home_panel.dart';
import 'widgets/game_over_panel.dart';
import 'widgets/pause_panel.dart';

class GameUI extends StatelessWidget {
  final SuikaGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: game.gameOverNotifier,
            builder: (_, over, __) =>
                over ? GameOverPanel(game: game) : const SizedBox.shrink(),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: game.isPausedNotifier,
            builder: (_, paused, __) =>
                paused ? PausePanel(game: game) : const SizedBox.shrink(),
          ),
          Positioned(top: 10, left: 12, right: 12, child: HudBar(game: game)),
        ],
      ),
    );
  }
}
