import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game_2048/utils/localization.dart';

import '../../game/suika_game.dart';
import 'button.dart';
import 'game_theme.dart';

class HudBar extends StatelessWidget {
  final SuikaGame game;
  const HudBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: game.gameStartedNotifier,
          builder: (_, started, __) {
            if (!started) return const SizedBox(width: 44);
            return ValueListenableBuilder<bool>(
              valueListenable: game.gameOverNotifier,
              builder: (_, over, __) {
                if (over) return const SizedBox(width: 44);
                return ValueListenableBuilder<bool>(
                  valueListenable: game.isPausedNotifier,
                  builder: (_, paused, __) => ThreeDButton(
                    shape: BoxShape.circle,
                    width: 50,
                    height: 50,
                    onPressed: game.togglePause,
                    child: Icon(
                      paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      color: Colors.white,
                      size: 28,
                      shadows: [
                        Shadow(
                          color: Color(0x55000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const Spacer(),
        ValueListenableBuilder<int>(
          valueListenable: game.scoreNotifier,
          builder: (_, v, __) => ValueListenableBuilder<String>(
            valueListenable: SuikaGame.langNotifier,
            builder: (_, lang, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScoreChip(
                  label: GameTexts.get('BALL'),
                  value: v,
                  accent: GameTheme.accent,
                ),
                const SizedBox(width: 10),
                ScoreChip(
                  label: GameTexts.get('REKORD'),
                  value: game.highScore,
                  accent: GameTheme.gold,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}

class ScoreChip extends StatelessWidget {
  final String label;
  final int value;
  final Color accent;
  const ScoreChip({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: GameTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.12),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontFamily: GameTheme.fontDisplay,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '$value',
            style: const TextStyle(
              color: GameTheme.black,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class NeonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const NeonIconButton({super.key, required this.icon, required this.onTap});

  void _handleTap() {
    FlameAudio.play('click.wav', volume: 0.5);
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: GameTheme.surfaceHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GameTheme.border, width: 1.5),
          boxShadow: [
            BoxShadow(color: GameTheme.accent.withOpacity(0.08), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: GameTheme.accent, size: 26),
      ),
    );
  }
}
