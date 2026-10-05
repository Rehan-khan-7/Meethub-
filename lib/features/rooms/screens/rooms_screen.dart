import 'package:flutter/material.dart';

import '../../../widgets/deskverse_header.dart';
import '../../../models/user.dart';
import '../../meetings/screens/meetings_screen.dart';
import '../../../models/user.dart';

class RoomsScreen extends StatefulWidget {
  final User user;
  final String? workspaceId;

  const RoomsScreen({super.key, required this.user, this.workspaceId});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Backend connect karne ke baad yahan actual rooms aayenge.
    final List rooms = [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: SafeArea(
        child: Column(
          children: [
            const DeskVerseHeader(workspaceName: 'Acme Corp HQ'),

            Expanded(
              child: rooms.isEmpty
                  ? _buildEmptyRooms()
                  : _buildRoomsList(rooms),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // =========================
  // EMPTY ROOMS
  // =========================

  Widget _buildEmptyRooms() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Rooms',
                style: TextStyle(
                  color: Color(0xFF202538),
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F1F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '0 rooms',
                  style: TextStyle(color: Color(0xFF73798B), fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'View and manage the rooms in your workspace.',
            style: TextStyle(color: Color(0xFF777E91), fontSize: 14),
          ),

          const SizedBox(height: 142),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(23, 32, 23, 29),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDDE1EA)),
            ),
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.meeting_room_outlined,
                    color: Color(0xFF2D5FEF),
                    size: 43,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'No rooms yet',
                  style: TextStyle(
                    color: Color(0xFF202538),
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Create your first room to give your team a place to\n'
                  'meet, work, and connect.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF777E91),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Create Room screen baad mein connect karenge.
                    },
                    icon: const Icon(Icons.add, size: 21),
                    label: const Text(
                      'Create Room',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5FEF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // ROOMS LIST
  // =========================

  Widget _buildRoomsList(List rooms) {
    return const Center(child: Text('Rooms will appear here'));
  }

  // =========================
  // BOTTOM NAVIGATION
  // =========================

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: const Color(0xFF2D5FEF),
      unselectedItemColor: const Color(0xFF7A8193),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      backgroundColor: Colors.white,
      elevation: 8,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.meeting_room_outlined),
          activeIcon: Icon(Icons.meeting_room),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.videocam),
          label: 'Meetings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],

      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
          return;
        }

        if (index == 2) {
          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeetingsScreen(
                user: widget.user,
                workspaceId: widget.workspaceId,
              ),
            ),
          );
        }
      },
    );
  }
}
