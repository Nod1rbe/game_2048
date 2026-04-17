import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../game/suika_game.dart';
import '../../utils/supabase_service.dart';
import 'game_theme.dart';
import 'button.dart';

class SettingsOverlay extends StatefulWidget {
  final SuikaGame game;
  final VoidCallback onClose;

  const SettingsOverlay({super.key, required this.game, required this.onClose});

  @override
  State<SettingsOverlay> createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.game.nicknameNotifier.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty || newName == widget.game.nicknameNotifier.value) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', newName);
    widget.game.nicknameNotifier.value = newName;
    
    // Sync with Supabase
    if (widget.game.userId.isNotEmpty) {
      await SupabaseService.upsertProfile(widget.game.userId, newName, widget.game.highScore);
    }
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Nickname updated!'), duration: Duration(seconds: 1)),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E), // Darker, cleaner background
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: GameTheme.accent.withOpacity(0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: GameTheme.accent.withOpacity(0.25),
                  blurRadius: 50,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SETTINGS',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Nickname Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'NICKNAME'.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: GameTheme.accent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: GameTheme.accent.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    cursorColor: GameTheme.accent,
                    decoration: InputDecoration(
                      hintText: 'Enter your name...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: _updateName,
                          icon: const Icon(Icons.save_rounded, color: GameTheme.accent, size: 28),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Language Selection
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LANGUAGE'.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: GameTheme.accent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<String>(
                  valueListenable: SuikaGame.langNotifier,
                  builder: (context, lang, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            width: (MediaQuery.of(context).size.width * 0.85 - 84) / 3,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: isSel 
                                ? const LinearGradient(
                                    colors: [GameTheme.accent, Color(0xFF6366F1)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                              color: isSel ? null : Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSel ? Colors.white.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                                width: 2,
                              ),
                              boxShadow: isSel ? [
                                BoxShadow(
                                  color: GameTheme.accent.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                )
                              ] : null,
                            ),
                            child: Center(
                              child: Text(
                                l.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: isSel ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 50),
                
                // Close Button
                ThreeDButton(
                  onPressed: widget.onClose,
                  width: double.infinity,
                  height: 65,
                  child: Text(
                    'DONE',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
