import 'package:flutter/material.dart';
import 'package:game_2048/utils/localization.dart';

import '../../game/suika_game.dart';
import 'button.dart';
import 'common_widgets.dart';
import 'game_theme.dart';

class PausePanel extends StatelessWidget {
  final SuikaGame game;
  const PausePanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SuikaGame.langNotifier,
      builder: (context, lang, _) {
        return OverlayPanel(
          child: PanelCard(
            borderColor: GameTheme.accent,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GameTheme.accent.withOpacity(0.1),
                  border: Border.all(
                    color: GameTheme.accent.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GameTheme.accent.withOpacity(0.15),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pause_rounded,
                  color: GameTheme.accent,
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                GameTexts.get('PAUZA'),
                style: TextStyle(
                  color: GameTheme.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  fontFamily: GameTheme.fontDisplay,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                GameTexts.get('O\'yin to\'xtatildi'),
                style: const TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const DividerLine(),
              ValueListenableBuilder<int>(
                valueListenable: game.scoreNotifier,
                builder: (_, v, __) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: GameTheme.surfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GameTheme.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        GameTexts.get('Joriy ball: '),
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$v',
                        style: const TextStyle(
                          color: GameTheme.accent,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
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
                    onPressed: () {
                      game.isPausedNotifier.value = false;
                      game.resumeEngine();
                      game.restart();
                    },
                    baseColor: const Color(0xFF7A0000),
                    gradientStart: const Color(0xFFFF5555),
                    gradientEnd: const Color(0xFFCC0000),
                    pressedGradientStart: const Color(0xFFCC0000),
                    pressedGradientEnd: const Color(0xFF990000),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  ThreeDButton(
                    shape: BoxShape.circle,
                    width: 60,
                    height: 60,
                    onPressed: game.togglePause,
                    child: const Icon(
                      Icons.play_arrow_rounded,
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
