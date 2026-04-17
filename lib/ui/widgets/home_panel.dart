import 'package:flutter/material.dart';
import 'package:game_2048/game/suika_game.dart';
import 'package:game_2048/ui/widgets/common_widgets.dart';
import 'package:game_2048/ui/widgets/hud_bar.dart';
import 'package:game_2048/utils/localization.dart';

import 'curved_bottom_bar.dart' show CurvedBottomBar;
import 'game_theme.dart';
import 'invite_friends_overlay.dart';

import 'leaderboard_panel.dart';

import 'settings_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePanel extends StatefulWidget {
  final SuikaGame game;
  const HomePanel({super.key, required this.game});

  @override
  State<HomePanel> createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  bool _showInvite = false;
  bool _showLeaderboard = false;
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          
          if (!_showLeaderboard) ...[
            // Score at top
            Positioned(
              top: 100, // Adjusted for header
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
            Center(
              child: OverlayPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        color: GameTheme.surfaceHigh,
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
                  ],
                ),
              ),
            ),
          ] else
            LeaderboardPanel(game: widget.game),

          // Header: Nickname and Settings (MOVED AFTER CENTER)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: widget.game.nicknameNotifier,
                    builder: (_, name, __) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            name,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _showSettings = true),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
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
              onLeaderboard: () => setState(() => _showLeaderboard = !_showLeaderboard),
            ),
          ),
          if (_showInvite)
            InviteFriendsOverlay(
              onClose: () => setState(() => _showInvite = false),
            ),
          if (_showSettings)
            SettingsOverlay(
              game: widget.game,
              onClose: () => setState(() => _showSettings = false),
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
