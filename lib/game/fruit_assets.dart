import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flame/extensions.dart';
import '../configs/fruit_config.dart';
import '../utils/polygon_tracer.dart';

class FruitAssets {
  static final Map<int, List<Vector2>> polys = {};
  static final Map<int, ui.Image> images = {};

  static Future<void> loadAll() async {
    for (final cfg in kFruits) {
      polys[cfg.level] = await PolygonTracer.trace(
        cfg.imagePath,
        n: 8,
        res: 64,
      );
      try {
        final data = await rootBundle.load(cfg.imagePath);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        images[cfg.level] = (await codec.getNextFrame()).image;
      } catch (_) {}
    }
  }
}
