import 'package:flutter/material.dart';
import 'package:game_2048/utils/localization.dart';

import '../../game/suika_game.dart';
import 'button.dart';
import 'common_widgets.dart';
import 'game_theme.dart';

class GameOverPanel extends StatelessWidget {
  final SuikaGame game;
  const GameOverPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SuikaGame.langNotifier,
      builder: (context, lang, _) {
        return OverlayPanel(
          child: PanelCard(
            borderColor: GameTheme.danger,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GameTheme.danger.withOpacity(0.12),
                  border: Border.all(
                    color: GameTheme.danger.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Text('💀', style: TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                GameTexts.get('O\'YIN TUGADI'),
                style: TextStyle(
                  color: GameTheme.danger,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontFamily: GameTheme.fontDisplay,
                  shadows: [
                    Shadow(
                      color: GameTheme.danger.withOpacity(0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
              const DividerLine(),
              ValueListenableBuilder<int>(
                valueListenable: game.scoreNotifier,
                builder: (_, v, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatBlock(
                      label: GameTexts.get('BALL'),
                      value: '$v',
                      color: GameTheme.accent,
                    ),
                    Container(width: 1, height: 40, color: GameTheme.border),
                    StatBlock(
                      label: GameTexts.get('REKORD'),
                      value: '${game.highScore}',
                      color: GameTheme.gold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ThreeDButton(
                    shape: BoxShape.circle,
                    width: 60,
                    height: 60,
                    onPressed: () {
                      game.goHome();
                      Navigator.of(context).pop();
                    },
                    baseColor: const Color(0xFF1E3A8A),
                    gradientStart: const Color(0xFF3B82F6),
                    gradientEnd: const Color(0xFF2563EB),
                    pressedGradientStart: const Color(0xFF1D4ED8),
                    pressedGradientEnd: const Color(0xFF1E40AF),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  ThreeDButton(
                    shape: BoxShape.circle,
                    width: 60,
                    height: 60,
                    onPressed: game.restart,
                    baseColor: const Color(0xFF7A0000),
                    gradientStart: const Color(0xFFFF5252),
                    gradientEnd: const Color(0xFFD32F2F),
                    pressedGradientStart: const Color(0xFFC62828),
                    pressedGradientEnd: const Color(0xFFB71C1C),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const StatBlock({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
