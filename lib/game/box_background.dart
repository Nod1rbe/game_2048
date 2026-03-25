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

    // Shisha akvarium fon (Glass background)
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14 / scale)),
      Paint()
        ..color = Colors.white.withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 2),
    );

    // Glass gradients/highlights
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.02),
          Colors.white.withOpacity(0.12),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14 / scale)),
      highlightPaint,
    );

    // Chegara (Glass Border)
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14 / scale)),
      Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 / scale,
    );

    // Additional glass highlight lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / scale;

    canvas.drawLine(
      Offset(boxL + 10 / scale, boxT + 10 / scale),
      Offset(boxL + (boxR - boxL) * 0.3, boxT + 10 / scale),
      linePaint,
    );
    canvas.drawLine(
      Offset(boxL + 10 / scale, boxT + 10 / scale),
      Offset(boxL + 10 / scale, boxT + (boxB - boxT) * 0.2),
      linePaint,
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
