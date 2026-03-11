import 'package:flutter/material.dart';

class FruitConfig {
  final int level;
  final String name;
  final String imagePath;
  final double radiusPx;
  final double density;
  final double restitution;
  final double friction;
  final Color fallbackColor;

  const FruitConfig({
    required this.level,
    required this.name,
    required this.imagePath,
    required this.radiusPx,
    required this.density,
    required this.restitution,
    required this.friction,
    required this.fallbackColor,
  });
}

const kFruits = [
  FruitConfig(
    level: 1,
    name: 'Olcha',
    imagePath: 'assets/cherry.png',
    radiusPx: 22,
    density: 1.0,
    restitution: 0.1,
    friction: 0.5,
    fallbackColor: Color(0xFFCC0000),
  ),
  FruitConfig(
    level: 2,
    name: 'Qulupnay',
    imagePath: 'assets/strawberry.png',
    radiusPx: 30,
    density: 1.1,
    restitution: 0.05,
    friction: 0.6,
    fallbackColor: Color(0xFFFF3355),
  ),
  FruitConfig(
    level: 3,
    name: 'Uzum',
    imagePath: 'assets/grape.png',
    radiusPx: 38,
    density: 1.2,
    restitution: 0.05,
    friction: 0.6,
    fallbackColor: Color(0xFF7B2FBE),
  ),
  FruitConfig(
    level: 4,
    name: 'Limon',
    imagePath: 'assets/lemon.png',
    radiusPx: 46,
    density: 1.1,
    restitution: 0.1,
    friction: 0.5,
    fallbackColor: Color(0xFFFFE234),
  ),
  FruitConfig(
    level: 5,
    name: 'Apelsin',
    imagePath: 'assets/orange.png',
    radiusPx: 55,
    density: 1.3,
    restitution: 0.05,
    friction: 0.6,
    fallbackColor: Color(0xFFFF8C00),
  ),
  FruitConfig(
    level: 6,
    name: 'Olma',
    imagePath: 'assets/apple.png',
    radiusPx: 64,
    density: 1.4,
    restitution: 0.05,
    friction: 0.6,
    fallbackColor: Color(0xFFDD2222),
  ),
  FruitConfig(
    level: 7,
    name: 'Shaftoli',
    imagePath: 'assets/peach.png',
    radiusPx: 74,
    density: 1.3,
    restitution: 0.05,
    friction: 0.6,
    fallbackColor: Color(0xFFFFB347),
  ),
  FruitConfig(
    level: 8,
    name: 'Mango',
    imagePath: 'assets/mango.png',
    radiusPx: 85,
    density: 1.5,
    restitution: 0.02,
    friction: 0.7,
    fallbackColor: Color(0xFFFF6B35),
  ),
  FruitConfig(
    level: 9,
    name: 'Tarvuz',
    imagePath: 'assets/watermelon.png',
    radiusPx: 97,
    density: 1.6,
    restitution: 0.02,
    friction: 0.7,
    fallbackColor: Color(0xFF00AA44),
  ),
  FruitConfig(
    level: 10,
    name: 'Ananas',
    imagePath: 'assets/pineapple.png',
    radiusPx: 110,
    density: 1.8,
    restitution: 0.02,
    friction: 0.7,
    fallbackColor: Color(0xFFFFCC00),
  ),
];
