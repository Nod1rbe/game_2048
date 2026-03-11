import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../configs/fruit_config.dart';
import 'fruit_assets.dart';
import 'suika_game.dart';

class FruitBody extends BodyComponent with ContactCallbacks {
  final FruitConfig cfg;
  final SuikaGame game;
  final Vector2 startPos;
  bool isStatic;
  final Vector2? initVel;
  final bool popIn;

  bool merged = false;
  double dangerTimer = 0;
  double _scale = 1.0;
  bool _growing = false;

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
  Body createBody() {
    final bd = BodyDef()
      ..type = isStatic ? BodyType.static : BodyType.dynamic
      ..position = startPos.clone()
      ..linearDamping = 0.5
      ..angularDamping = 1.2
      ..allowSleep = true;

    final body = world.createBody(bd);
    _addFixture(body);
    if (initVel != null) body.linearVelocity = initVel!.clone();
    return body;
  }

  void _addFixture(Body body) {
    final rawVerts = FruitAssets.polys[cfg.level] ?? [];
    Shape shape;

    // Padding (2.5px metrda)
    final paddedR = _mRadius + (2.5 / SuikaGame.scale);

    if (rawVerts.length >= 3) {
      final verts = rawVerts
          .map((v) => Vector2(v.x * paddedR * 2, v.y * paddedR * 2))
          .toList();

      final area = _signedArea(verts);
      final ordered = area < 0 ? verts : verts.reversed.toList();

      try {
        shape = PolygonShape()..set(ordered);
      } catch (_) {
        shape = CircleShape()..radius = paddedR;
      }
    } else {
      shape = CircleShape()..radius = paddedR;
    }

    body.createFixture(
      FixtureDef(shape)
        ..density = cfg.density
        ..restitution = cfg.restitution
        ..friction = cfg.friction
        ..userData = this,
    );
  }

  double _signedArea(List<Vector2> pts) {
    double area = 0;
    for (int i = 0; i < pts.length; i++) {
      final j = (i + 1) % pts.length;
      area += pts[i].x * pts[j].y;
      area -= pts[j].x * pts[i].y;
    }
    return area / 2;
  }

  void activate() {
    isStatic = false;
    body.setType(BodyType.dynamic);
    body.setAwake(true);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is FruitBody && !merged && !other.merged) {
      game.tryMerge(this, other);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_growing) {
      _scale = (_scale + dt * 6).clamp(0.0, 1.0);
      if (_scale >= 1.0) _growing = false;
    }
  }

  @override
  void render(Canvas canvas) {
    if (merged) return;

    final r = _mRadius;

    if (_scale < 1.0) {
      canvas.save();
      canvas.scale(_scale, _scale);
    }

    if (dangerTimer > 0.4 && !isStatic) {
      canvas.drawCircle(
        Offset.zero,
        r * 1.3,
        Paint()
          ..color = Colors.redAccent.withOpacity(
            (dangerTimer / 1.8 * 0.5).clamp(0.0, 0.5),
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.4),
      );
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
        filterQuality: FilterQuality.medium,
      );
    } else {
      canvas.drawCircle(Offset.zero, r, Paint()..color = cfg.fallbackColor);
    }

    if (_scale < 1.0) canvas.restore();
  }
}
