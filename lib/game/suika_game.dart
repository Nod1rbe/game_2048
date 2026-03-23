import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/fruit_config.dart';
import '../utils/localization.dart';
import 'box_background.dart';
import 'fruit_assets.dart';
import 'fruit_body.dart';

class SuikaGame extends Forge2DGame with TapCallbacks, DragCallbacks {
  static const double scale = 20.0;

  SuikaGame() : super(gravity: Vector2(0, 150), zoom: scale);

  @override
  Color backgroundColor() => const Color(0xFF0D1F0D);

  late double screenW, screenH;
  late double boxL, boxR, boxT, boxB;
  late double wallThick, dropY, dangerY;

  FruitBody? _pending;
  bool _canDrop = true;
  bool gameOver = false;
  int score = 0;
  int highScore = 0;

  final List<FruitBody> _activeFruits = [];
  final Map<String, int> _lastPlayedTimes = {}; // For audio throttling

  late AudioPool _dropSoundPool;
  late AudioPool _bloopPool;
  late AudioPool _merge1SoundPool;
  late AudioPool _merge3SoundPool;

  final scoreNotifier = ValueNotifier<int>(0);
  final gameOverNotifier = ValueNotifier<bool>(false);
  final gameStartedNotifier = ValueNotifier<bool>(false);
  final isPausedNotifier = ValueNotifier<bool>(false);
  static final langNotifier = ValueNotifier<String>('uz');

  @override
  Future<void> onLoad() async {
    await FruitAssets.loadAll();
    await FlameAudio.audioCache.loadAll([
      'click.wav',
      'new_drop.wav',
      'bloop.mp3',
      'merge1.mp3',
      'merge3.mp3',
    ]);

    _dropSoundPool = await FlameAudio.createPool('new_drop.wav', maxPlayers: 4);
    _bloopPool = await FlameAudio.createPool('bloop.mp3', maxPlayers: 4);
    _merge1SoundPool = await FlameAudio.createPool('merge1.mp3', maxPlayers: 2);
    _merge3SoundPool = await FlameAudio.createPool('merge3.mp3', maxPlayers: 2);

    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    langNotifier.value = prefs.getString('lang') ?? 'uz';

    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.zoom = scale;

    world.physicsWorld.setAllowSleep(true);

    screenW = size.x / scale;
    screenH = size.y / scale;

    wallThick = 15.0 / scale;
    final margin = screenW * 0.05;
    final yOffset = size.y * 0.08 / scale; // Raise container up by 8% of screen
    
    boxL = margin;
    boxR = screenW - margin;
    boxT = (size.y * 0.4) / scale - yOffset;
    boxB = screenH - margin - yOffset;

    dropY = boxT - (90.0 / scale);
    dangerY = boxT - (30.0 / scale);

    world.add(
      BoxBackground(
        boxL: boxL,
        boxR: boxR,
        boxT: boxT,
        boxB: boxB,
        dangerY: dangerY,
      ),
    );

    _buildWalls();
  }

  void _buildWalls() {
    _staticBox(
      cx: (boxL + boxR) / 2,
      cy: boxB + wallThick / 2,
      hw: (boxR - boxL) / 2 + wallThick,
      hh: wallThick / 2,
    );
    _staticBox(
      cx: boxL - wallThick / 2,
      cy: (boxT + boxB) / 2,
      hw: wallThick / 2,
      hh: (boxB - boxT) / 2 + wallThick,
    );
    _staticBox(
      cx: boxR + wallThick / 2,
      cy: (boxT + boxB) / 2,
      hw: wallThick / 2,
      hh: (boxB - boxT) / 2 + wallThick,
    );
  }

  void _staticBox({
    required double cx,
    required double cy,
    required double hw,
    required double hh,
  }) {
    final bd = BodyDef()
      ..type = BodyType.static
      ..position = Vector2(cx, cy);
    world
        .createBody(bd)
        .createFixture(
          FixtureDef(PolygonShape()..setAsBoxXY(hw, hh))
            ..friction = 0.8
            ..restitution = 0.0,
        );
  }

  void _spawnPending() {
    if (gameOver || !gameStartedNotifier.value) return;
    final cfg = kFruits[Random().nextInt(4)];
    final cx = (boxL + boxR) / 2;
    _pending = FruitBody(
      cfg: cfg,
      game: this,
      startPos: Vector2(cx, dropY - (cfg.radiusPx + 20) / scale),
      isStatic: true,
    );
    _canDrop = true;
    world.add(_pending!);
  }

  double? _pendingX;

  void moveTo(double screenX) {
    if (_pending == null ||
        !_canDrop ||
        gameOver ||
        !gameStartedNotifier.value ||
        isPausedNotifier.value)
      return;
    final r = (_pending!.cfg.radiusPx + 15) / scale;
    final mX = screenX / scale;
    _pendingX = mX.clamp(boxL + r, boxR - r);
    try {
      _pending!.body.setTransform(
        Vector2(_pendingX!, dropY - (_pending!.cfg.radiusPx + 20) / scale),
        0,
      );
    } catch (_) {}
  }

  void drop() {
    if (_pending == null ||
        !_canDrop ||
        gameOver ||
        !gameStartedNotifier.value ||
        isPausedNotifier.value)
      return;
    if (_pendingX != null) {
      final r = _pending!.cfg.radiusPx / scale;
      try {
        _pending!.body.setTransform(
          Vector2(_pendingX!, dropY - r - (20 / scale)),
          0,
        );
      } catch (_) {}
    }
    _canDrop = false;
    _pendingX = null;
    _pending!.activate();
    _pending = null;

    _playSound('new_drop.wav', volume: 0.7);

    Future.delayed(const Duration(milliseconds: 400), _spawnPending);
  }

  void _playSound(String path, {double volume = 0.5}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _lastPlayedTimes[path] ?? 0;
    if (now - lastTime > 60) {
      if (path == 'new_drop.wav') {
        _dropSoundPool.start(volume: volume);
      } else if (path == 'merge1.mp3') {
        _merge1SoundPool.start(volume: volume);
      } else if (path == 'merge3.mp3') {
        _merge3SoundPool.start(volume: volume);
      } else {
        FlameAudio.play(path, volume: volume);
      }
      _lastPlayedTimes[path] = now;
    }
  }

  /// Called from FruitBody when a fruit first touches a surface
  void playContactSound() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _lastPlayedTimes['contact'] ?? 0;
    if (now - lastTime > 80) {
      _bloopPool.start(volume: 0.5);
      _lastPlayedTimes['contact'] = now;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    moveTo(event.canvasPosition.x);
    drop();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    moveTo(event.localStartPosition.x);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    drop();
  }

  double _comboTimer = 0;
  int _comboCount = 0;

  final List<(FruitBody, FruitBody)> _mergeQueue = [];

  void tryMerge(FruitBody a, FruitBody b) {
    if (a.merged || b.merged) return;
    if (a.cfg.level != b.cfg.level) return;
    if (a.cfg.level >= kFruits.length) return;
    a.merged = b.merged = true;
    _mergeQueue.add((a, b));
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

      vel.y -= 15.0; // Pop-up impulse for juiciness

      score += a.cfg.level * 20;
      if (score > highScore) {
        highScore = score;
        SharedPreferences.getInstance().then(
          (prefs) => prefs.setInt('highScore', highScore),
        );
      }
      scoreNotifier.value = score;
      if (a.isMounted) a.removeFromParent();
      if (b.isMounted) b.removeFromParent();
      world.add(
        FruitBody(
          cfg: kFruits[a.cfg.level],
          game: this,
          startPos: mid,
          initVel: vel,
          popIn: true,
        ),
      );
    }

    if (mergedThisFrame > 0) {
      _comboCount += mergedThisFrame;
      _comboTimer = 2.0;

      if (_comboCount >= 2) {
        _playSound('merge3.mp3', volume: 0.5);
      } else {
        _playSound('merge1.mp3', volume: 0.5);
      }

      String msg = "";
      if (_comboCount == 2)
        msg = GameTexts.get("Ajoyib!");
      else if (_comboCount == 3)
        msg = GameTexts.get("Combo x3!");
      else if (_comboCount > 3)
        msg = GameTexts.get("Dahshat!");

      if (msg.isNotEmpty) {
        final screenPos = lastMid * SuikaGame.scale;
        camera.viewport.add(ComboText(msg, screenPos));
      }
    }
  }

  void triggerGameOver() {
    if (gameOver) return;
    gameOver = true;
    gameOverNotifier.value = true;
    _pending?.removeFromParent();
    _pending = null;
  }

  void startGame() {
    gameStartedNotifier.value = true;
    isPausedNotifier.value = false;
    resumeEngine();
    restart();
  }

  void togglePause() {
    if (gameOver || !gameStartedNotifier.value) return;
    isPausedNotifier.value = !isPausedNotifier.value;
    if (isPausedNotifier.value) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }

  void restart() {
    _mergeQueue.clear();
    _activeFruits
        .clear(); // Will be repopulated as components are removed/added
    _pendingX = null;
    world.children.whereType<FruitBody>().toList().forEach(
      (f) => f.removeFromParent(),
    );
    score = 0;
    scoreNotifier.value = 0;
    gameOver = false;
    gameOverNotifier.value = false;
    Future.delayed(const Duration(milliseconds: 150), _spawnPending);
  }

  void goHome() {
    isPausedNotifier.value = false;
    gameOverNotifier.value = false;
    gameStartedNotifier.value = false;
    _mergeQueue.clear();
    _activeFruits.clear();
    _pendingX = null;
    _pending?.removeFromParent();
    _pending = null;
    world.children.whereType<FruitBody>().toList().forEach(
      (f) => f.removeFromParent(),
    );
    score = 0;
    scoreNotifier.value = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) _comboCount = 0;
    }
    _processMergeQueue();

    if (gameOver) return;
    for (int i = 0; i < _activeFruits.length; i++) {
      final f = _activeFruits[i];
      if (f.isStatic || f.merged || !f.isMounted) continue;
      final fR = f.cfg.radiusPx / scale;
      if (f.body.position.y - fR < dangerY) {
        f.dangerTimer += dt;
        if (f.dangerTimer > 1.8) {
          triggerGameOver();
          return;
        }
      } else {
        f.dangerTimer = 0;
      }
    }
  }

  void registerFruit(FruitBody f) => _activeFruits.add(f);
  void unregisterFruit(FruitBody f) => _activeFruits.remove(f);
}

class ComboText extends PositionComponent {
  final String text;
  double lifeTimer = 0.0;
  final double maxLife = 1.0;

  late final TextPainter _painter;
  late final TextPainter _shadowPainter;

  static const _textStyle = TextStyle(
    color: Colors.yellowAccent,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const _shadowStyle = TextStyle(
    color: Colors.black,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  ComboText(this.text, Vector2 pos) : super(position: pos) {
    _painter = TextPainter(
      text: TextSpan(text: text, style: _textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    _shadowPainter = TextPainter(
      text: TextSpan(text: text, style: _shadowStyle),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void update(double dt) {
    super.update(dt);
    lifeTimer += dt;
    position.y -= 100 * dt;
    if (lifeTimer >= maxLife) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final alpha = (1.0 - (lifeTimer / maxLife)).clamp(0.0, 1.0);
    canvas.saveLayer(null, Paint()..color = Colors.white.withOpacity(alpha));
    _shadowPainter.paint(
      canvas,
      Offset(-_painter.width / 2 + 2, -_painter.height / 2 + 2),
    );
    _painter.paint(canvas, Offset(-_painter.width / 2, -_painter.height / 2));
    canvas.restore();
  }
}
