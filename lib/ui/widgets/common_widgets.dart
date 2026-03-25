import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'game_theme.dart';

class OverlayPanel extends StatelessWidget {
  final Widget child;
  const OverlayPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GameTheme.gradientStart.withOpacity(0.15),
      child: Center(child: child),
    );
  }
}

class PanelCard extends StatelessWidget {
  final List<Widget> children;
  final Color? borderColor;
  const PanelCard({super.key, required this.children, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        color: GameTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor ?? GameTheme.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (borderColor ?? GameTheme.accent).withOpacity(0.15),
            blurRadius: 32,
            spreadRadius: 2,
          ),
          const BoxShadow(color: Color(0x66000000), blurRadius: 16),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final double? width;
  const PrimaryBtn({super.key, required this.label, required this.onTap, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    final c = color ?? GameTheme.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: c.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          widthFactor: 1.0,
          child: Text(
            label,
            style: TextStyle(
              color: c == GameTheme.accent ? Colors.black : Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontFamily: GameTheme.fontDisplay,
            ),
          ),
        ),
      ),
    );
  }
}

class GhostBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final double? width;
  const GhostBtn({super.key, required this.label, required this.onTap, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    final c = color ?? GameTheme.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withOpacity(0.5), width: 1.5),
        ),
        child: Center(
          widthFactor: 1.0,
          child: Text(
            label,
            style: TextStyle(
              color: c,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontFamily: GameTheme.fontDisplay,
            ),
          ),
        ),
      ),
    );
  }
}

class DividerLine extends StatelessWidget {
  const DividerLine({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: GameTheme.border,
    margin: const EdgeInsets.symmetric(vertical: 20),
  );
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            GameTheme.gradientStart,
            GameTheme.gradientEnd,
          ],
        ),
      ),
      child: const DecorativeShapes(),
    );
  }
}

class DecorativeShapes extends StatelessWidget {
  const DecorativeShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildShape(Icons.close, -0.7, -0.6, 0.5, 24),
        _buildShape(Icons.panorama_fish_eye, 0.6, -0.8, 0.3, 32),
        _buildShape(Icons.change_history, -0.6, 0.4, 0.2, 40),
        _buildShape(Icons.crop_square, 0.4, 0.6, 0.4, 32),
        _buildShape(Icons.close, 0.8, -0.2, 0.6, 20),
        _buildShape(Icons.panorama_fish_eye, -0.4, -0.2, 1.2, 48),
        _buildShape(Icons.change_history, 0.2, -0.4, 0.5, 28),
        _buildShape(Icons.add, -0.7, 0.1, 0.4, 36),
        _buildShape(Icons.add, 0.8, 0.7, -0.3, 30),
      ],
    );
  }

  Widget _buildShape(IconData icon, double y, double x, double rot, double size) {
    return Align(
      alignment: Alignment(x, y),
      child: Transform.rotate(
        angle: rot,
        child: Opacity(
          opacity: 0.15,
          child: Icon(
            icon,
            size: size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
