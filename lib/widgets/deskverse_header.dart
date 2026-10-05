import 'package:flutter/material.dart';

class DeskVerseHeader extends StatelessWidget {
  final String workspaceName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  const DeskVerseHeader({
    super.key,
    this.workspaceName = 'Acme Corp HQ',
    this.onNotificationTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF202538),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.diamond_outlined,
                color: Colors.white,
                size: 31,
              ),

              const SizedBox(width: 8),

              const Text(
                'DeskVerse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ],
          ),

          Text(
            '$workspaceName⌄',
            style: const TextStyle(
              color: Color(0xFFD0D4E0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}