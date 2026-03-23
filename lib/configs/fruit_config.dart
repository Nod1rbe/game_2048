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
    name: 'Turp',
    imagePath: 'assets/radish.png',
    radiusPx: 18,
    density: 1.05,
    restitution: 0.1,
    friction: 0.6,
    fallbackColor: Color(0xFFE81E63),
  ),
  FruitConfig(
    level: 2,
    name: 'Mangostin',
    imagePath: 'assets/mangosteen.png',
    radiusPx: 24,
    density: 1.1,
    restitution: 0.1,
    friction: 0.6,
    fallbackColor: Color(0xFF4A148C),
  ),
  FruitConfig(
    level: 3,
    name: 'Limon',
    imagePath: 'assets/lemon.png',
    radiusPx: 30,
    density: 0.95,
    restitution: 0.2,
    friction: 0.5,
    fallbackColor: Color(0xFFFFEB3B),
  ),
  FruitConfig(
    level: 4,
    name: 'Olma',
    imagePath: 'assets/apple.png',
    radiusPx: 36,
    density: 0.85,
    restitution: 0.2,
    friction: 0.5,
    fallbackColor: Color(0xFFF44336),
  ),
  FruitConfig(
    level: 5,
    name: 'Shaftoli',
    imagePath: 'assets/peach.png',
    radiusPx: 44,
    density: 1.0,
    restitution: 0.15,
    friction: 0.6,
    fallbackColor: Color(0xFFFFCC80),
  ),
  FruitConfig(
    level: 6,
    name: 'Nok',
    imagePath: 'assets/pear.png',
    radiusPx: 51,
    density: 0.9,
    restitution: 0.15,
    friction: 0.6,
    fallbackColor: Color(0xFFD4E157),
  ),
  FruitConfig(
    level: 7,
    name: 'Mango',
    imagePath: 'assets/mango.png',
    radiusPx: 59,
    density: 1.05,
    restitution: 0.1,
    friction: 0.6,
    fallbackColor: Color(0xFFFFB300),
  ),
  FruitConfig(
    level: 8,
    name: 'Kokos',
    imagePath: 'assets/coconut.png',
    radiusPx: 68,
    density: 1.15,
    restitution: 0.05,
    friction: 0.8,
    fallbackColor: Color(0xFF795548),
  ),

  FruitConfig(
    level: 9,
    name: 'Qovoq',
    imagePath: 'assets/pumpkin.png',
    radiusPx: 77,
    density: 0.8,
    restitution: 0.05,
    friction: 0.7,
    fallbackColor: Color(0xFFFF5722),
  ),
  FruitConfig(
    level: 10,
    name: 'Tarvuz',
    imagePath: 'assets/watermelon.png',
    radiusPx: 88,
    density: 0.95,
    restitution: 0.05,
    friction: 0.7,
    fallbackColor: Color(0xFF4CAF50),
  ),
];
