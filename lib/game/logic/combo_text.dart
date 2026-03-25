import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

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
