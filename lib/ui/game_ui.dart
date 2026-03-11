import 'package:flutter/material.dart';

import '../game/suika_game.dart';

class GameUI extends StatelessWidget {
  final SuikaGame game;
  const GameUI({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: game.scoreNotifier,
                builder: (_, v, __) => _ScoreBox('BALL', v, Colors.greenAccent),
              ),
              const SizedBox(width: 20),
              ValueListenableBuilder<int>(
                valueListenable: game.scoreNotifier,
                builder: (_, __, ___) =>
                    _ScoreBox('REKORD', game.highScore, Colors.amber),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: game.gameOverNotifier,
          builder: (_, over, __) =>
              over ? _GameOverPanel(game: game) : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _ScoreBox(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.4), width: 2),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class _GameOverPanel extends StatelessWidget {
  final SuikaGame game;
  const _GameOverPanel({required this.game});
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black87,
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A1A),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.greenAccent, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏁', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              "O'YIN TUGADI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<int>(
              valueListenable: game.scoreNotifier,
              builder: (_, v, __) => Text(
                'Ball: $v',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: game.restart,
              child: const Text(
                'YANA O\'YNASH',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
