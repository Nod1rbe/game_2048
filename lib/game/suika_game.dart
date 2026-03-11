import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../configs/fruit_config.dart';
import 'box_background.dart';
import 'fruit_assets.dart';
import 'fruit_body.dart';

class SuikaGame extends Forge2DGame with TapCallbacks, DragCallbacks {
  static const double scale = 20.0;

  SuikaGame() : super(gravity: Vector2(0, 250), zoom: scale);

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

  final scoreNotifier = ValueNotifier<int>(0);
  final gameOverNotifier = ValueNotifier<bool>(false);

  @override
  Future<void> onLoad() async {
    await FruitAssets.loadAll();

    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.zoom = scale;

    world.physicsWorld.setAllowSleep(true);

    screenW = size.x / scale;
    screenH = size.y / scale;

    wallThick = 15.0 / scale;
    final margin = screenW * 0.05;
    boxL = margin;
    boxR = screenW - margin;
    boxT = (size.y * 0.12) / scale;
    boxB = screenH - margin;

    dropY = boxT + (60.0 / scale);
    dangerY = boxT + (90.0 / scale);

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
    _spawnPending();
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
            ..restitution = 0.02,
        );
  }

  void _spawnPending() {
    if (gameOver) return;
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
    if (_pending == null || !_canDrop || gameOver) return;
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
    if (_pending == null || !_canDrop || gameOver) return;
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
    Future.delayed(const Duration(milliseconds: 400), _spawnPending);
  }

  @override
  void onTapUp(TapUpEvent event) {
    moveTo(event.canvasPosition.x);
    Future.delayed(Duration.zero, drop);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    moveTo(event.localStartPosition.x);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    drop();
  }

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
    final queue = List.of(_mergeQueue);
    _mergeQueue.clear();
    for (final (a, b) in queue) {
      final mid = (a.body.position + b.body.position) * 0.5;
      final vel = (a.body.linearVelocity + b.body.linearVelocity) * 0.5;
      score += a.cfg.level * 20;
      if (score > highScore) highScore = score;
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
  }

  void triggerGameOver() {
    if (gameOver) return;
    gameOver = true;
    gameOverNotifier.value = true;
    _pending?.removeFromParent();
    _pending = null;
  }

  void restart() {
    _mergeQueue.clear();
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

  @override
  void update(double dt) {
    super.update(dt);
    _processMergeQueue();

    if (gameOver) return;
    for (final f in world.children.whereType<FruitBody>()) {
      if (f.isStatic || f.merged) continue;
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
}
