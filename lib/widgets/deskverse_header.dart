import 'package:flutter/material.dart';

import '../models/user.dart';
import '../features/more/screens/profile_screen.dart';

class DeskVerseHeader extends StatelessWidget {
  final String workspaceName;
  final User? user;
  final String? workspaceId;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  const DeskVerseHeader({
    super.key,
    this.workspaceName = 'Acme Corp HQ',
    this.user,
    this.workspaceId,
    this.onNotificationTap,
    this.onMenuTap,
  });

  void _openDrawer(BuildContext context) {
    if (Scaffold.of(context).hasDrawer) {
      Scaffold.of(context).openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
                    onPressed:
                        onNotificationTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifications coming soon'),
                            ),
                          );
                        },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  IconButton(
                    onPressed:
                        onMenuTap ??
                        () {
                          _openDrawer(context);
                        },
                    icon: const Icon(Icons.menu, color: Colors.white, size: 27),
                  ),
                ],
              ),

              Text(
                '$workspaceName⌄',
                style: const TextStyle(color: Color(0xFFD0D4E0), fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
