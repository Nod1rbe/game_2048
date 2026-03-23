import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class ThreeDButton extends StatefulWidget {
  final String? label;
  final Widget? child;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color baseColor;
  final Color gradientStart;
  final Color gradientEnd;
  final Color pressedGradientStart;
  final Color pressedGradientEnd;
  final BoxShape shape;

  const ThreeDButton({
    super.key,
    this.label,
    this.child,
    required this.onPressed,
    this.width = 260,
    this.height = 60,
    this.baseColor = const Color(0xFF3a7d0a),
    this.gradientStart = const Color(0xFF7fe832),
    this.gradientEnd = const Color(0xFF5cc010),
    this.pressedGradientStart = const Color(0xFF5ab81a),
    this.pressedGradientEnd = const Color(0xFF4caf0f),
    this.shape = BoxShape.rectangle,
  }) : assert(label != null || child != null);

  @override
  State<ThreeDButton> createState() => _ThreeDButtonState();
}

class _ThreeDButtonState extends State<ThreeDButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  static const double _shadowDepth = 6.0;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    FlameAudio.play('click.wav', volume: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.translationValues(
          0,
          _isPressed ? _shadowDepth : 0,
          0,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: _isPressed ? 0 : -_shadowDepth,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.baseColor,
                  borderRadius: widget.shape == BoxShape.circle ? null : BorderRadius.circular(16),
                  shape: widget.shape,
                ),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _isPressed
                      ? [widget.pressedGradientStart, widget.pressedGradientEnd]
                      : [widget.gradientStart, widget.gradientEnd],
                ),
                borderRadius: widget.shape == BoxShape.circle ? null : BorderRadius.circular(16),
                shape: widget.shape,
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: widget.child ?? Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Color(0x55000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
