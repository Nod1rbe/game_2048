import 'package:flutter/material.dart';
import 'package:game_2048/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../game/suika_game.dart';
import 'button.dart';
import 'common_widgets.dart';
import 'game_theme.dart';

class HomePanel extends StatelessWidget {
  final SuikaGame game;
  const HomePanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SuikaGame.langNotifier,
      builder: (context, lang, _) {
        return OverlayPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['uz', 'ru', 'en'].map((l) {
                  final isSel = lang == l;
                  return GestureDetector(
                    onTap: () {
                      SuikaGame.langNotifier.value = l;
                      SharedPreferences.getInstance().then(
                        (p) => p.setString('lang', l),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSel ? GameTheme.accent : GameTheme.surfaceHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? Colors.white : GameTheme.border,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        l.toUpperCase(),
                        style: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF6A9A6A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GameTheme.surfaceHigh,
                  border: Border.all(
                    color: GameTheme.accent.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GameTheme.accent.withOpacity(0.2),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🍉', style: TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                GameTexts.get('SUIKA'),
                style: TextStyle(
                  color: GameTheme.accent,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  fontFamily: GameTheme.fontDisplay,
                  shadows: [
                    Shadow(
                      color: GameTheme.accent.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                GameTexts.get('MEVALARNI BIRLASHTIRING'),
                style: const TextStyle(
                  color: Color(0xFF6A9A6A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 48),
              ThreeDButton(
                shape: BoxShape.circle,
                width: 100,
                height: 100,
                onPressed: game.startGame,
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 64,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color(0x55000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HintTile extends StatelessWidget {
  final String icon;
  final String text;
  const HintTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF5A8A5A),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
