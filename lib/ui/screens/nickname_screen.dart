import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_2048/ui/widgets/common_widgets.dart';
import 'package:game_2048/utils/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

import '../../game/suika_game.dart';

class NicknameScreen extends StatefulWidget {
  final SuikaGame game;
  const NicknameScreen({super.key, required this.game});

  @override
  State<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
                children: [
                  const GradientBackground(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'QUIZZE!',
                            style: GoogleFonts.outfit(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: 'GAME'.split('').map((char) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  char,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 80),
                          Text(
                            'Nickname',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _controller,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4F46E5),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 20),
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: () async {
                              if (_controller.text.isNotEmpty) {
                                final prefs = await SharedPreferences.getInstance();
                                String userId = prefs.getString('userId') ?? const Uuid().v4();
                                
                                await prefs.setString('userId', userId);
                                await prefs.setString('nickname', _controller.text);
                                
                                final highScore = prefs.getInt('highScore') ?? 0;
                                await SupabaseService.upsertProfile(userId, _controller.text, highScore);
                                
                                // Direct sync with the game engine!
                                await widget.game.loadPrefs();
                                
                                if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF8585), Color(0xFFFF4D4D)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF4D4D).withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        
