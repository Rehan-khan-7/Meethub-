import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../models/workspace.dart';
import '../../../models/room.dart';

import '../../../services/workspace_service.dart';
import '../../../services/room_service.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkspaceService workspaceService = WorkspaceService();
  final RoomService roomService = RoomService();

  List<Workspace> workspaces = [];
  List<Room> rooms = [];
  int totalPeople = 0;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final loadedWorkspaces = await workspaceService.getWorkspaces();

      List<Room> loadedRooms = [];

      if (loadedWorkspaces.isNotEmpty) {
        loadedRooms = await roomService.getRooms(loadedWorkspaces.first.id);
      }

      if (!mounted) return;

      setState(() {
        workspaces = loadedWorkspaces;
        rooms = loadedRooms;

        if (loadedWorkspaces.isNotEmpty) {
          totalPeople = loadedWorkspaces.first.members.length;
        }

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint('Home data error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 72,
                color: const Color(0xFF14263D),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Meethub
                    const Text(
                      "◯ Workverse",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),

                    const SizedBox(width: 14),

                    // Vertical line
                    Container(height: 25, width: 1, color: Colors.white30),

                    const SizedBox(width: 14),

                    // Company
                    const Text(
                      "Acme Corp HQ⌄",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),

                    const Spacer(),

                    // Notification
                    const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 22,
                    ),

                    const SizedBox(width: 16),

                    // Profile
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.user.name.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: Color(0xFF14263D),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Workspace Manager",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14263D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Your people and spaces, at a glance.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFDCE4DE),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 20,
                            color: Color(0xFF718096),
                          ),

                          const SizedBox(width: 8),

                          const Text(
                            "Search rooms or people",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFDCE4DE),
                          width: 1,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Office overview",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF14263D),
                                ),
                              ),

                              const Spacer(),

                              // fullscreen wala box
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "${rooms.length} rooms · ${totalPeople} people",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF718096),
                            ),
                          ),

                          const SizedBox(height: 16),

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rooms.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1.2,
                                ),
                            itemBuilder: (context, index) {
                              final room = rooms[index];

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF14263D),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      room.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF14263D),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: room.members.map((member) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 14,
                                                child: Text(
                                                  member[0],
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 3),

                                              Text(
                                                member,
                                                style: const TextStyle(
                                                  fontSize: 8,
                                                  color: Color(0xFF718096),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 16,
                                color: Color(0xFF718096),
                              ),

                              const SizedBox(width: 6),

                              const Text(
                                "People in the workspace",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                ),
                              ),

                              const Spacer(),

                              Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2879D8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Add Room functionality baad mein
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    "Add Room",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =====================================================
                    // WORKSPACE ANALYTICS
                    // =====================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F6F6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD0E8E8),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Workspace Analytics",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF14263D),
                                ),
                              ),

                              const Spacer(),

                              const Icon(
                                Icons.bar_chart,
                                color: Color(0xFF3FA3A3),
                                size: 20,
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF3FA3A3),
                                    width: 4,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "96%",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF14263D),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Attendance",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "96%",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF14263D),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Engagement",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "High",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xFF3FA3A3),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =====================================================
                    // PENDING TASKS
                    // =====================================================
                    Row(
                      children: [
                        const Text(
                          "Pending Tasks",
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF14263D),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "3",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2879D8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFDCE4DE)),
                      ),
                      child: Column(
                        children: [
                          _buildTaskRow("Review Design Specs"),

                          const Divider(height: 1, color: Color(0xFFDCE4DE)),

                          _buildTaskRow("Complete Onboarding Call"),

                          const Divider(height: 1, color: Color(0xFFDCE4DE)),

                          _buildTaskRow("Q4 Planning Prep"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =====================================================
                    // AI MEETING SUMMARIES
                    // =====================================================
                    Row(
                      children: [
                        const Text(
                          "AI Meeting Summaries",
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF14263D),
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF2879D8),
                          size: 20,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFDCE4DE)),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow("Q3 Sync Notes"),

                          const Divider(height: 1, color: Color(0xFFDCE4DE)),

                          _buildSummaryRow("Feature Brainstorm"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        currentIndex: 0,

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
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_outlined),
            activeIcon: Icon(Icons.meeting_room),
            label: "Rooms",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined),
            activeIcon: Icon(Icons.videocam),
            label: "Meetings",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            activeIcon: Icon(Icons.check_box),
            label: "Tasks",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more_horiz),
            label: "More",
          ),
        ],
      ),
    );
  }
}

Widget _buildTaskRow(String title) {
  return SizedBox(
    height: 51,
    child: Row(
      children: [
        const SizedBox(width: 13),

        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFB8C7D9), width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF14263D)),
          ),
        ),

        const Icon(Icons.chevron_right, color: Color(0xFF718096), size: 20),

        const SizedBox(width: 8),
      ],
    ),
  );
}

Widget _buildSummaryRow(String title) {
  return SizedBox(
    height: 58,
    child: Row(
      children: [
        const SizedBox(width: 13),

        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.description_outlined,
            color: Color(0xFF2879D8),
            size: 18,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF14263D)),
          ),
        ),

        const Icon(Icons.chevron_right, color: Color(0xFF2879D8), size: 20),

        const SizedBox(width: 8),
      ],
    ),
  );
}
