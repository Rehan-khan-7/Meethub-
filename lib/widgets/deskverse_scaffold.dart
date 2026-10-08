import 'package:flutter/material.dart';

import '../models/user.dart';
import 'deskverse_header.dart';
import 'deskverse_drawer.dart';
import 'deskverse_bottom_nav.dart';

class DeskVerseScaffold extends StatelessWidget {
  final Widget body;
  final String workspaceName;
  final User user;
  final String workspaceId;
  final int currentIndex;

  const DeskVerseScaffold({
    super.key,
    required this.body,
    required this.user,
    required this.workspaceId,
    required this.currentIndex,
    this.workspaceName = 'Acme Corp HQ',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // Shared drawer
      drawer: DeskVerseDrawer(user: user, workspaceId: workspaceId),

      // Shared header + screen content
      body: SafeArea(
        child: Column(
          children: [
            DeskVerseHeader(workspaceName: workspaceName),

            Expanded(child: body),
          ],
        ),
      ),

      // Shared bottom navigation
      bottomNavigationBar: DeskVerseBottomNav(
        currentIndex: currentIndex,
        user: user,
        workspaceId: workspaceId,
      ),
    );
  }
}
