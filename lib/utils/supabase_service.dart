import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<void> upsertProfile(String id, String nickname, int highScore) async {
    try {
      await _client.from('profiles').upsert({
        'id': id,
        'nickname': nickname,
        'high_score': highScore,
        'updated_at': DateTime.now().toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('highScore_synced', true);
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('highScore_synced', false);
    }
  }

  static Future<List<Map<String, dynamic>>> getLeaderboard({String? currentUserId, int? currentUserScore, String? currentUserNickname}) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check cache first
    final cachedData = prefs.getString('leaderboard_cache');
    List<Map<String, dynamic>> results = [];
    if (cachedData != null) {
      try {
        results = List<Map<String, dynamic>>.from(jsonDecode(cachedData));
      } catch (_) {}
    }

    try {
      final response = await _client
          .from('profiles')
          .select('nickname, high_score')
          .order('high_score', ascending: false)
          .limit(30); // LIMIT TO 30
      
      results = List<Map<String, dynamic>>.from(response);
      await prefs.setString('leaderboard_cache', jsonEncode(results));
    } catch (e) {
      // If offline, use results from cache
    }

    // Merge current player if they have a better score or are missing
    if (currentUserNickname != null && currentUserScore != null) {
      bool found = false;
      for (int i = 0; i < results.length; i++) {
        if (results[i]['nickname'] == currentUserNickname) {
          if (currentUserScore > results[i]['high_score']) {
            results[i]['high_score'] = currentUserScore;
          }
          found = true;
          break;
        }
      }
      
      if (!found) {
        results.add({
          'nickname': currentUserNickname,
          'high_score': currentUserScore,
        });
      }
      
      // Re-sort and keep top 30
      results.sort((a, b) => (b['high_score'] as int).compareTo(a['high_score'] as int));
      if (results.length > 30) {
        results = results.sublist(0, 30);
      }
    }

    return results;
  }

  static Future<void> syncPendingScore(String id, String nickname, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final isSynced = prefs.getBool('highScore_synced') ?? true;
    
    if (!isSynced) {
      await upsertProfile(id, nickname, score);
    }
  }

  static Future<void> updateHighScore(String id, String nickname, int score) async {
    await upsertProfile(id, nickname, score);
  }
}
