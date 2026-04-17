import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_2048/utils/supabase_service.dart';
import 'package:game_2048/game/suika_game.dart';

class LeaderboardPanel extends StatelessWidget {
  final SuikaGame game;
  const LeaderboardPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 100), // Space for top navigation buttons
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 140), // Space for bottom bar
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: SupabaseService.getLeaderboard(
                  currentUserId: game.userId,
                  currentUserScore: game.highScore,
                  currentUserNickname: game.nicknameNotifier.value,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  final data = snapshot.data ?? [];
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: data.length,
                    separatorBuilder: (_, _) => Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                    itemBuilder: (context, index) {
                      final profile = data[index];
                      return _LeaderboardTile(
                        rank: index + 1,
                        name: profile['nickname'] ?? 'Anonymous',
                        score: profile['high_score'] ?? 0,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;

  const _LeaderboardTile({required this.rank, required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTop3 ? Colors.white : Colors.transparent,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: GoogleFonts.outfit(
                  color: isTop3 ? const Color(0xFF4F46E5) : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: isTop3 ? FontWeight.w900 : FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Text(
            score.toString(),
            style: GoogleFonts.outfit(
              color: isTop3 ? const Color(0xFFFFD700) : Colors.white70,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
