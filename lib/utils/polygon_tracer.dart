import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';

class PolygonTracer {
  static Future<List<Vector2>> trace(
    String path, {
    int n = 8,
    int res = 64,
  }) async {
    try {
      final data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: res,
        targetHeight: res,
      );
      final img = (await codec.getNextFrame()).image;
      final bytes = (await img.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!.buffer.asUint8List();
      final w = img.width;
      final h = img.height;

      final pts = <ui.Offset>[];
      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final alpha = bytes[(y * w + x) * 4 + 3];
          if (alpha > 40) {
            pts.add(ui.Offset(x.toDouble(), y.toDouble()));
          }
        }
      }
      if (pts.length < 3) return _circle(n);

      final norm = pts.map((p) => Vector2(p.dx / w - 0.5, p.dy / h - 0.5)).toList();
      return _convexHull(norm, n);
    } catch (e) {
      return _circle(n);
    }
  }

  static List<Vector2> _circle(int n) => List.generate(n, (i) {
    final a = 2 * pi * i / n;
    return Vector2(cos(a) * 0.48, sin(a) * 0.48);
  });

  static List<Vector2> _convexHull(List<Vector2> pts, int n) {
    if (pts.length < 3) return _circle(n);
    final s = [...pts]
      ..sort((a, b) => a.y != b.y ? a.y.compareTo(b.y) : a.x.compareTo(b.x));
    final piv = s.first;
    s.sort(
      (a, b) => atan2(
        a.y - piv.y,
        a.x - piv.x,
      ).compareTo(atan2(b.y - piv.y, b.x - piv.x)),
    );
    final h = <Vector2>[];
    for (final p in s) {
      while (h.length >= 2) {
        final cross =
            (h.last.x - h[h.length - 2].x) * (p.y - h[h.length - 2].y) -
            (h.last.y - h[h.length - 2].y) * (p.x - h[h.length - 2].x);
        if (cross <= 0)
          h.removeLast();
        else
          break;
      }
      h.add(p);
    }
    
    if (h.length > n) {
      final step = h.length / n;
      return List.generate(n, (i) => h[(i * step).floor() % h.length]);
    }
    return h.length >= 3 ? h : _circle(n);
  }
}
