import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:game_2048/game/logic/fruit_physics.dart';

import '../configs/fruit_config.dart';
import 'fruit_assets.dart';
import 'suika_game.dart';

class FruitBody extends BodyComponent with ContactCallbacks {
  final FruitConfig cfg;
  @override
  final SuikaGame game;
  final Vector2 startPos;
  bool isStatic;
  final Vector2? initVel;
  final bool popIn;

  bool merged = false;
  double dangerTimer = 0;
  double _scale = 1.0;
  bool _growing = false;
  bool _hasTouched = false;

  final Vector2 _lastVel = Vector2.zero();
  final Vector2 _scaleVisual = Vector2(1, 1);

  static final Paint _glowPaint = Paint()..style = PaintingStyle.fill;
  static final Map<double, MaskFilter> _blurCache = {};
  static const int _blurCacheMaxSize = 10;

  @override
  void onMount() {
    super.onMount();
    game.registerFruit(this);
  }

  @override
  void onRemove() {
    game.unregisterFruit(this);
    super.onRemove();
  }

  FruitBody({
    required this.cfg,
    required this.game,
    required this.startPos,
    this.isStatic = false,
    this.initVel,
    this.popIn = false,
  }) {
    if (popIn) {
      _scale = 0.2;
      _growing = true;
    }
  }

  double get _mRadius => cfg.radiusPx / SuikaGame.scale;

  @override
  Body createBody() => FruitPhysics.create(
    world,
    cfg: cfg,
    pos: startPos,
    isStatic: isStatic,
    vel: initVel,
    userData: this,
  );

  void activate() {
    isStatic = false;
    body.gravityScale = Vector2.all(1.0);
    body.setAwake(true);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is FruitBody && !merged && !other.merged) {
      game.tryMerge(this, other);
    }

    // Play a 'diq' drop sound when this fruit first hits anything
    if (!isStatic && !merged && !_hasTouched) {
      _hasTouched = true;
      game.audio.playContactSound();
    }

    if (!isStatic && !merged) {
      // In beginContact, velocity is the pre-resolution velocity.
      final speed = body.linearVelocity.length;
      if (speed > 30) {
        // More noticeable squish based on speed
        final squeeze = (speed / 350).clamp(0.0, 0.35);
        _scaleVisual.x = 1.0 + squeeze;
        _scaleVisual.y = 1.0 - squeeze;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_growing) {
      _scale = (_scale + dt * 6).clamp(0.0, 1.0);
      if (_scale >= 1.0) _growing = false;
    }

    if (!isStatic && !merged) {
      _lastVel.setFrom(body.linearVelocity);
    }

    // recover shape safely preventing overshoot on frame drops
    final recovery = (dt * 10).clamp(0.0, 1.0);
    _scaleVisual.x += (1.0 - _scaleVisual.x) * recovery;
    _scaleVisual.y += (1.0 - _scaleVisual.y) * recovery;
  }

  @override
  void render(Canvas canvas) {
    if (merged) return;

    final r = _mRadius;

    canvas.save();

    try {
      canvas.rotate(-body.angle);
      canvas.scale(_scaleVisual.x, _scaleVisual.y);
      canvas.rotate(body.angle);
    } catch (_) {}

    if (_scale < 1.0) {
      canvas.scale(_scale, _scale);
    }

    if (dangerTimer > 0.4 && !isStatic) {
      final blurRadius =
          (r * 0.4 * 2).roundToDouble() / 2; // round to 0.5 steps
      _glowPaint.color = Colors.redAccent.withValues(
        alpha: (dangerTimer / 1.8 * 0.5).clamp(0.0, 0.5),
      );
      if (!_blurCache.containsKey(blurRadius)) {
        if (_blurCache.length >= _blurCacheMaxSize) {
          _blurCache.remove(_blurCache.keys.first);
        }
        _blurCache[blurRadius] = MaskFilter.blur(BlurStyle.normal, blurRadius);
      }
      _glowPaint.maskFilter = _blurCache[blurRadius];
      canvas.drawCircle(Offset.zero, r * 1.3, _glowPaint);
    }

    final img = FruitAssets.images[cfg.level];
    if (img != null) {
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: r * 2,
        height: r * 2,
      );
      paintImage(
        canvas: canvas,
        rect: rect,
        image: img,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.low,
      );
    } else {
      canvas.drawCircle(Offset.zero, r, Paint()..color = cfg.fallbackColor);
    }

    canvas.restore();
  }
}
