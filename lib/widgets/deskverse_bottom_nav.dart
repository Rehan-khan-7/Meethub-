import 'package:flutter/material.dart';

import '../features/more/screens/more_screen.dart';
import '../features/tasks/screens/tasks_screen.dart';
import '../models/user.dart';
import '../features/home/screens/home_screen.dart';
import '../features/rooms/screens/rooms_screen.dart';
import '../features/meetings/screens/meetings_screen.dart';

class DeskVerseBottomNav extends StatelessWidget {
  final int currentIndex;
  final User user;
  final String workspaceId;

  const DeskVerseBottomNav({
    super.key,
    required this.currentIndex,
    required this.user,
    required this.workspaceId,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = HomeScreen(user: user);
        break;

      case 1:
        screen = RoomsScreen(user: user, workspaceId: workspaceId);
        break;

      case 2:
        screen = MeetingsScreen(user: user, workspaceId: workspaceId);
        break;

      case 3:
        screen = TasksScreen(user: user, workspaceId: workspaceId);
        break;

      case 4:
        screen = MoreScreen(user: user, workspaceId: workspaceId);
        break;

      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      selectedItemColor: const Color(0xFF2879D8),
      unselectedItemColor: const Color(0xFF718096),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      backgroundColor: Colors.white,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.meeting_room_outlined),
          activeIcon: Icon(Icons.meeting_room),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videocam_outlined),
          activeIcon: Icon(Icons.videocam),
          label: 'Meetings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box_outlined),
          activeIcon: Icon(Icons.check_box),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          activeIcon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }
}
