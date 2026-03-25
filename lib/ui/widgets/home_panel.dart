import 'package:flutter/material.dart';
import 'package:game_2048/game/suika_game.dart';
import 'package:game_2048/ui/widgets/common_widgets.dart';
import 'package:game_2048/ui/widgets/hud_bar.dart';
import 'package:game_2048/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'curved_bottom_bar.dart';
import 'game_theme.dart';
import 'invite_friends_overlay.dart';

class HomePanel extends StatefulWidget {
  final SuikaGame game;
  const HomePanel({super.key, required this.game});

  @override
  State<HomePanel> createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  bool _showInvite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          // Score at top
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: ValueListenableBuilder<int>(
              valueListenable: widget.game.scoreNotifier,
              builder: (_, v, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScoreChip(
                    label: GameTexts.get('BALL'),
                    value: v,
                    accent: GameTheme.accent,
                  ),
                  const SizedBox(width: 12),
                  ScoreChip(
                    label: GameTexts.get('REKORD'),
                    value: widget.game.highScore,
                    accent: GameTheme.gold,
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<String>(
            valueListenable: SuikaGame.langNotifier,
            builder: (context, lang, _) {
              return Center(
                child: OverlayPanel(
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
                                color: isSel
                                    ? GameTheme.accent
                                    : GameTheme.surfaceHigh,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel
                                      ? Colors.white
                                      : GameTheme.border,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                l.toUpperCase(),
                                style: TextStyle(
                                  color: isSel
                                      ? Colors.white
                                      : const Color(
                                          0xFF6366F1,
                                        ).withOpacity(0.7),
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
                      const SizedBox(height: 10),
                      Text(
                        GameTexts.get('MEVALARNI BIRLASHTIRING'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF6366F1),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CurvedBottomBar(
              onPlay: () {
                widget.game.startGame();
                Navigator.pushNamed(context, '/game');
              },
              onInvite: () => setState(() => _showInvite = true),
              onLeaderboard: () {},
            ),
          ),
          if (_showInvite)
            InviteFriendsOverlay(
              onClose: () => setState(() => _showInvite = false),
            ),
        ],
      ),
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
            color: Color(0xFF6366F1),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
