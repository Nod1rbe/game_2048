import 'package:flutter/material.dart';
import 'game_theme.dart';

class CurvedBottomBar extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onInvite;
  final VoidCallback onLeaderboard;

  const CurvedBottomBar({
    super.key,
    required this.onPlay,
    required this.onInvite,
    required this.onLeaderboard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 140),
            painter: CurvePainter(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25, left: 40, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _MenuIconButton(
                  icon: Icons.emoji_events_rounded,
                  onTap: onLeaderboard,
                  isSmall: true,
                ),
                _MenuIconButton(
                  icon: Icons.play_arrow_rounded,
                  onTap: onPlay,
                  isLarge: true,
                ),
                _MenuIconButton(
                  icon: Icons.person_add_alt_1_rounded,
                  onTap: onInvite,
                  isSmall: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLarge;
  final bool isSmall;

  const _MenuIconButton({
    required this.icon,
    required this.onTap,
    this.isLarge = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    double size = isLarge ? 85 : 65;
    double iconSize = isLarge ? 50 : 32;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLarge ? Colors.white : Colors.white.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: isLarge ? GameTheme.accent : Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.5, -20, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
