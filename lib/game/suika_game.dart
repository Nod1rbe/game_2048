import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/fruit_config.dart';
import 'box_background.dart';
import 'fruit_assets.dart';
import 'fruit_body.dart';
import 'logic/audio_manager.dart';
import 'logic/merge_handler.dart';

class SuikaGame extends Forge2DGame with TapCallbacks, DragCallbacks {
  static const double scale = 20.0;
  SuikaGame() : super(gravity: Vector2(0, 150), zoom: scale);

  @override
  Color backgroundColor() => Colors.transparent;

  late double screenW, screenH, boxL, boxR, boxT, boxB, wallThick, dropY, dangerY;
  FruitBody? _pending;
  bool _canDrop = true, gameOver = false;
  int score = 0, highScore = 0;
  final List<FruitBody> _activeFruits = [];
  final audio = AudioManager();
  late final MergeHandler _merger = MergeHandler(this);

  final scoreNotifier = ValueNotifier<int>(0);
  final gameOverNotifier = ValueNotifier<bool>(false);
  final gameStartedNotifier = ValueNotifier<bool>(false);
  final isPausedNotifier = ValueNotifier<bool>(false);
  static final langNotifier = ValueNotifier<String>('uz');

  @override
  Future<void> onLoad() async {
    await FruitAssets.loadAll();
    await audio.init();
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    langNotifier.value = prefs.getString('lang') ?? 'uz';
    camera.viewfinder.anchor = Anchor.topLeft;
    world.physicsWorld.setAllowSleep(true);
    _setupLayout();
    world.add(BoxBackground(boxL: boxL, boxR: boxR, boxT: boxT, boxB: boxB, dangerY: dangerY));
    _buildWalls();
    if (gameStartedNotifier.value) restart();
  }

  void _setupLayout() {
    screenW = size.x / scale; screenH = size.y / scale;
    wallThick = 15.0 / scale;
    final margin = screenW * 0.05, yOff = size.y * 0.08 / scale;
    boxL = margin; boxR = screenW - margin;
    boxT = (size.y * 0.4) / scale - yOff; boxB = screenH - margin - yOff;
    dropY = boxT - (90.0 / scale); dangerY = boxT - (30.0 / scale);
  }

  void _buildWalls() {
    _wall((boxL + boxR) / 2, boxB + wallThick / 2, (boxR - boxL) / 2 + wallThick, wallThick / 2);
    _wall(boxL - wallThick / 2, (boxT + boxB) / 2, wallThick / 2, (boxB - boxT) / 2 + wallThick);
    _wall(boxR + wallThick / 2, (boxT + boxB) / 2, wallThick / 2, (boxB - boxT) / 2 + wallThick);
  }

  void _wall(double x, double y, double hw, double hh) {
    world.createBody(BodyDef()..type = BodyType.static..position = Vector2(x, y))
        .createFixture(FixtureDef(PolygonShape()..setAsBoxXY(hw, hh))..friction = 0.8..restitution = 0.0);
  }

  void _spawnPending() {
    if (gameOver || !gameStartedNotifier.value) return;
    final cfg = kFruits[Random().nextInt(4)];
    _pending = FruitBody(cfg: cfg, game: this, 
        startPos: Vector2((boxL + boxR) / 2, dropY - (cfg.radiusPx + 20) / scale), isStatic: true);
    _canDrop = true;
    world.add(_pending!);
  }

  void moveTo(double sX) {
    if (_pending == null || !_canDrop || gameOver || !gameStartedNotifier.value || isPausedNotifier.value) return;
    final r = (_pending!.cfg.radiusPx + 15) / scale;
    final pX = (sX / scale).clamp(boxL + r, boxR - r);
    _pending!.body.setTransform(Vector2(pX, dropY - (_pending!.cfg.radiusPx + 20) / scale), 0);
  }

  void drop() {
    if (_pending == null || !_canDrop || gameOver || !gameStartedNotifier.value || isPausedNotifier.value) return;
    _canDrop = false; _pending!.activate(); _pending = null;
    audio.playSound('new_drop.wav', volume: 0.7);
    Future.delayed(const Duration(milliseconds: 400), _spawnPending);
  }

  @override void onTapUp(TapUpEvent e) { moveTo(e.canvasPosition.x); drop(); }
  @override void onDragUpdate(DragUpdateEvent e) => moveTo(e.localStartPosition.x);
  @override void onDragEnd(DragEndEvent e) => drop();

  void tryMerge(FruitBody a, FruitBody b) => _merger.tryMerge(a, b);

  void startGame() {
    gameStartedNotifier.value = true; isPausedNotifier.value = false;
    resumeEngine(); if (isLoaded) restart();
  }

  void togglePause() {
    if (gameOver || !gameStartedNotifier.value) return;
    isPausedNotifier.value = !isPausedNotifier.value;
    isPausedNotifier.value ? pauseEngine() : resumeEngine();
  }

  void restart() {
    _merger.clear(); _activeFruits.clear();
    world.children.whereType<FruitBody>().forEach((f) => f.removeFromParent());
    score = 0; scoreNotifier.value = 0; gameOver = false; gameOverNotifier.value = false;
    Future.delayed(const Duration(milliseconds: 150), _spawnPending);
  }

  void goHome() {
    isPausedNotifier.value = false; gameOverNotifier.value = false; gameStartedNotifier.value = false;
    _merger.clear(); _activeFruits.clear(); _pending?.removeFromParent(); _pending = null;
    world.children.whereType<FruitBody>().forEach((f) => f.removeFromParent());
    score = 0; scoreNotifier.value = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _merger.update(dt);
    if (gameOver) return;
    for (final f in _activeFruits) {
      if (f.isStatic || f.merged || !f.isMounted) continue;
      if (f.body.position.y - f.cfg.radiusPx / scale < dangerY) {
        f.dangerTimer += dt;
        if (f.dangerTimer > 1.8) { gameOver = true; gameOverNotifier.value = true; _pending?.removeFromParent(); _pending = null; return; }
      } else f.dangerTimer = 0;
    }
  }

  void registerFruit(FruitBody f) => _activeFruits.add(f);
  void unregisterFruit(FruitBody f) => _activeFruits.remove(f);
}
