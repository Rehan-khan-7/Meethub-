import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../widgets/deskverse_bottom_nav.dart';

class MoreScreen extends StatelessWidget {
  final User user;
  final String workspaceId;

  const MoreScreen({super.key, required this.user, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF202538),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202538),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6E8EF)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFEAF1FF),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2879D8),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF202538),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF73798C),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF73798C)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildSectionTitle('Workspace'),

          _buildOption(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'Manage your account',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile screen coming next.')),
              );
            },
          ),

          _buildOption(
            icon: Icons.group_add_outlined,
            title: 'Invite Members',
            subtitle: 'Add people to your workspace',
            onTap: () {},
          ),

          const SizedBox(height: 12),

          _buildSectionTitle('App'),

          _buildOption(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Manage notifications',
            onTap: () {},
          ),

          _buildOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'App preferences',
            onTap: () {},
          ),

          _buildOption(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with VOW',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // Logout
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE05252),
                side: const BorderSide(color: Color(0xFFE8B4B4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DeskVerseBottomNav(
        currentIndex: 4,
        user: user,
        workspaceId: workspaceId,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF73798C),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E8EF)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF2879D8)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202538),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Color(0xFF73798C)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA0B1)),
      ),
    );
  }
}
