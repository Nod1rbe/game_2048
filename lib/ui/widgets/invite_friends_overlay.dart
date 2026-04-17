import 'package:flutter/material.dart';
import 'package:game_2048/utils/localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriendsOverlay extends StatelessWidget {
  final VoidCallback onClose;
  const InviteFriendsOverlay({super.key, required this.onClose});

  Future<void> _inviteContacts(BuildContext context) async {
    try {
      final Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: '',
        queryParameters: <String, String>{
          'body': 'Hey! Check out this cool fruit game: https://game2048.page.link/invite',
        },
      );
      await launchUrl(smsLaunchUri);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open SMS. Please restart the app.')),
        );
      }
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    try {
      await Share.share(
        'Join me in FruitMerge! Can you merge the watermelon? 🍉 https://game2048.page.link/invite',
        subject: 'Invite Friends!',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sharing failed. Please restart the app.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.5),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    GameTexts.get('DO\'STLARNI TAKLIF QILISH'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InviteButton(
                    icon: Icons.contact_phone_rounded,
                    label: GameTexts.get('Kontaktlarni taklif qilish'),
                    onTap: () => _inviteContacts(context),
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(height: 16),
                  _InviteButton(
                    icon: Icons.share,
                    label: GameTexts.get('Facebook orqali taklif qilish'),
                    onTap: () => _shareApp(context),
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InviteButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _InviteButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
