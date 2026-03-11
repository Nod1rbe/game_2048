import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'suika_game.dart';

class BoxBackground extends Component {
  final double boxL, boxR, boxT, boxB, dangerY;

  BoxBackground({
    required this.boxL,
    required this.boxR,
    required this.boxT,
    required this.boxB,
    required this.dangerY,
  });

  @override
  int get priority => -10;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTRB(boxL, boxT, boxR, boxB);
    final scale = SuikaGame.scale;

    // Fon
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14 / scale)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D2B0D), Color(0xFF1A3A1A)],
        ).createShader(rect),
    );

    // Chegara
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14 / scale)),
      Paint()
        ..color = const Color(0xFF2E7D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 / scale,
    );

    // Danger chizig'i
    final dashPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.5)
      ..strokeWidth = 2 / scale;

    double dx = boxL + 8 / scale;
    while (dx < boxR - 8 / scale) {
      canvas.drawLine(
        Offset(dx, dangerY),
        Offset((dx + 12 / scale).clamp(boxL, boxR - 8 / scale), dangerY),
        dashPaint,
      );
      dx += 22 / scale;
    }
  }
}
