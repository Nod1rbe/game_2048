import 'package:flame/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/fruit_config.dart';
import '../fruit_body.dart';
import '../suika_game.dart';
import 'combo_text.dart';

class MergeHandler {
  final SuikaGame game;
  final List<(FruitBody, FruitBody)> _mergeQueue = [];
  int _comboCount = 0;
  double _comboTimer = 0;

  MergeHandler(this.game);

  void tryMerge(FruitBody a, FruitBody b) {
    if (a.merged || b.merged) return;
    if (a.cfg.level != b.cfg.level) return;
    if (a.cfg.level >= kFruits.length) return;
    a.merged = b.merged = true;
    _mergeQueue.add((a, b));
  }

  void update(double dt) {
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) _comboCount = 0;
    }
    _processMergeQueue();
  }

  void clear() {
    _mergeQueue.clear();
    _comboCount = 0;
    _comboTimer = 0;
  }

  void _processMergeQueue() {
    if (_mergeQueue.isEmpty) return;
    int mergedThisFrame = 0;
    final queue = List.of(_mergeQueue);
    _mergeQueue.clear();
    Vector2 lastMid = Vector2.zero();

    for (final (a, b) in queue) {
      mergedThisFrame++;
      final mid = (a.body.position + b.body.position) * 0.5;
      lastMid = mid;
      final vel = (a.body.linearVelocity + b.body.linearVelocity) * 0.5;
      vel.y -= 15.0;

      game.score += a.cfg.level * 20;
      if (game.score > game.highScore) {
        game.highScore = game.score;
        SharedPreferences.getInstance().then(
          (prefs) => prefs.setInt('highScore', game.highScore),
        );
      }
      game.scoreNotifier.value = game.score;
      if (a.isMounted) a.removeFromParent();
      if (b.isMounted) b.removeFromParent();
      game.world.add(
        FruitBody(
          cfg: kFruits[a.cfg.level],
          game: game,
          startPos: mid,
          initVel: vel,
          popIn: true,
        ),
      );
    }

    if (mergedThisFrame > 0) {
      _comboCount += mergedThisFrame;
      _comboTimer = 2.0;
      game.audio.playSound(_comboCount >= 2 ? 'merge3.mp3' : 'merge1.mp3');
      _showComboMsg(_comboCount, lastMid);
    }
  }

  void _showComboMsg(int combo, Vector2 pos) {
    String msg = "";
    if (combo == 2) msg = "Ajoyib!";
    else if (combo == 3) msg = "Combo x3!";
    else if (combo > 3) msg = "Dahshat!";

    if (msg.isNotEmpty) {
      game.camera.viewport.add(ComboText(msg, pos * SuikaGame.scale));
    }
  }
}
