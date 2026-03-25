import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_2048/configs/fruit_config.dart';
import 'package:game_2048/game/fruit_assets.dart';
import 'package:game_2048/game/suika_game.dart';

class FruitPhysics {
  static Body create(
    Forge2DWorld world, {
    required FruitConfig cfg,
    required Vector2 pos,
    required bool isStatic,
    Vector2? vel,
    required Object userData,
  }) {
    final bd = BodyDef()
      ..type = BodyType.dynamic
      ..gravityScale = isStatic ? Vector2.zero() : Vector2.all(1.0)
      ..position = pos.clone()
      ..linearDamping = 0.8
      ..angularDamping = 1.5
      ..allowSleep = true;

    final body = world.createBody(bd);
    final r = cfg.radiusPx / SuikaGame.scale;
    final paddedR = r + (2.5 / SuikaGame.scale);

    final rawVerts = FruitAssets.polys[cfg.level] ?? [];
    Shape shape;

    if (rawVerts.length >= 3) {
      final verts = rawVerts
          .map((v) => Vector2(v.x * paddedR * 2, v.y * paddedR * 2))
          .toList();
      _ensureClockwise(verts);
      try {
        shape = PolygonShape()..set(verts);
      } catch (_) {
        shape = CircleShape()..radius = paddedR;
      }
    } else {
      shape = CircleShape()..radius = paddedR;
    }

    body.createFixture(
      FixtureDef(shape)
        ..density = cfg.density
        ..restitution = 0.0
        ..friction = cfg.friction
        ..userData = userData,
    );
    if (vel != null) body.linearVelocity = vel.clone();
    return body;
  }

  static void _ensureClockwise(List<Vector2> pts) {
    double area = 0;
    for (int i = 0; i < pts.length; i++) {
      final j = (i + 1) % pts.length;
      area += pts[i].x * pts[j].y - pts[j].x * pts[i].y;
    }
    if (area > 0) pts.setAll(0, pts.reversed.toList());
  }
}
