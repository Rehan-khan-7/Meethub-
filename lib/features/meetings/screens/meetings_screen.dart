import 'package:flutter/material.dart';

import '../../../models/meeting.dart';
import '../../../models/user.dart';
import '../../../services/meeting_service.dart';

class MeetingsScreen extends StatefulWidget {
  final User user;
  final String? workspaceId;

  const MeetingsScreen({
    super.key,
    required this.user,
    this.workspaceId,
  });

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  final MeetingService meetingService = MeetingService();

  List<Meeting> meetings = [];

  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadMeetings();
  }

  Future<void> loadMeetings() async {
    if (widget.workspaceId == null) {
      setState(() {
        meetings = _mockMeetings();
        isLoading = false;
      });
      return;
    }

    try {
      final data = await meetingService.getMeetings(
        widget.workspaceId!,
      );

      setState(() {
        meetings = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Meeting error: $e');

      setState(() {
        meetings = _mockMeetings();
        isLoading = false;
      });
    }
  }

  List<Meeting> _mockMeetings() {
    final now = DateTime.now();

    return [
      Meeting(
        id: '1',
        workspaceId: 'workspace',
        roomId: 'room',
        title: 'Product Roadmap Sync',
        description: '',
        createdBy: widget.user.id,
        participants: [
          'A',
          'B',
          'C',
          'D',
          'E',
          'F',
        ],
        startTime: DateTime(
          now.year,
          now.month,
          now.day,
          14,
          0,
        ),
        endTime: DateTime(
          now.year,
          now.month,
          now.day,
          15,
          0,
        ),
        meetingCode: 'ROADMAP',
        meetingLink: 'https://vow.app/meeting/roadmap',
        status: 'active',
      ),

      Meeting(
        id: '2',
        workspaceId: 'workspace',
        roomId: 'room',
        title: 'Engineering Standup',
        description: '',
        createdBy: widget.user.id,
        participants: [],
        startTime: DateTime(
          now.year,
          now.month,
          now.day,
          16,
          0,
        ),
        endTime: DateTime(
          now.year,
          now.month,
          now.day,
          16,
          30,
        ),
        meetingCode: 'ENGINEER',
        meetingLink: 'https://vow.app/meeting/engineering',
        status: 'scheduled',
      ),

      Meeting(
        id: '3',
        workspaceId: 'workspace',
        roomId: 'room',
        title: 'Marketing Strategy Session',
        description: '',
        createdBy: widget.user.id,
        participants: [],
        startTime: DateTime(
          now.year,
          now.month,
          now.day,
          11,
          0,
        ),
        endTime: DateTime(
          now.year,
          now.month,
          now.day,
          12,
          0,
        ),
        meetingCode: 'MARKETING',
        meetingLink: 'https://vow.app/meeting/marketing',
        status: 'scheduled',
      ),
    ];
  }

  List<Meeting> get filteredMeetings {
    if (searchQuery.trim().isEmpty) {
      return meetings;
    }

    return meetings.where((meeting) {
      return meeting.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  String formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
            ? 12
            : time.hour;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  String formatDuration(
    DateTime start,
    DateTime end,
  ) {
    final minutes = end.difference(start).inMinutes;

    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      return '${hours}h';
    }

    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredMeetings;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  20,
                  22,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),

                    const SizedBox(height: 18),

                    _buildSearch(),

                    const SizedBox(height: 12),

                    _buildScheduleButton(),

                    const SizedBox(height: 16),

                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ...filtered.map(
                        (meeting) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _buildMeetingCard(meeting),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 112,
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        16,
      ),
      color: const Color(0xFF202638),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.diamond_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                'DeskVerse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 27,
              ),

              const SizedBox(width: 20),

              const Icon(
                Icons.menu,
                color: Colors.white,
                size: 27,
              ),
            ],
          ),

          const SizedBox(height: 5),

          const Row(
            children: [
              Text(
                'Acme Corp HQ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              SizedBox(width: 4),

              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white70,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        const Text(
          'Meetings',
          style: TextStyle(
            color: Color(0xFF252A3A),
            fontSize: 29,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEFF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${meetings.length} today',
            style: const TextStyle(
              color: Color(0xFF73798C),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFDCE0EA),
        ),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF73798C),
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Color(0xFF858B9D),
            fontSize: 13,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          // Schedule meeting screen will be added next.
        },
        icon: const Icon(
          Icons.add,
          size: 22,
        ),
        label: const Text(
          'Schedule New Meeting',
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
    );
  }

  Widget _buildMeetingCard(Meeting meeting) {
    final isActive = meeting.status == 'active';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        15,
        15,
        14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD7DAE7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  meeting.title,
                  style: const TextStyle(
                    color: Color(0xFF252A3A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Icon(
                Icons.more_horiz,
                color: Color(0xFF7B8191),
              ),
            ],
          ),

          if (meeting.participants.isNotEmpty) ...[
            const SizedBox(height: 10),

            SizedBox(
              height: 30,
              child: Row(
                children: List.generate(
                  meeting.participants.length > 6
                      ? 6
                      : meeting.participants.length,
                  (index) {
                    return Align(
                      widthFactor: 0.72,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            Colors.primaries[index %
                                Colors.primaries.length],
                        child: Text(
                          meeting.participants[index]
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 17,
                color: Color(0xFF7B8191),
              ),

              const SizedBox(width: 7),

              Text(
                'Today, ${formatTime(meeting.startTime)} – '
                '${formatTime(meeting.endTime)} '
                '(${formatDuration(meeting.startTime, meeting.endTime)})',
                style: const TextStyle(
                  color: Color(0xFF73798C),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color: Color(0xFF7B8191),
              ),

              const SizedBox(width: 7),

              const Text(
                'Location: Design Studio (Virtual)',
                style: TextStyle(
                  color: Color(0xFF73798C),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              if (isActive) ...[
                const Icon(
                  Icons.circle,
                  size: 7,
                  color: Color(0xFF29A36A),
                ),

                const SizedBox(width: 5),

                const Text(
                  'Recurring (Weekly)',
                  style: TextStyle(
                    color: Color(0xFF29A36A),
                    fontSize: 11,
                  ),
                ),
              ] else
                const Text(
                  'Not started',
                  style: TextStyle(
                    color: Color(0xFF7B8191),
                    fontSize: 11,
                  ),
                ),

              const Spacer(),

              SizedBox(
                width: 82,
                height: 40,
                child: ElevatedButton(
                  onPressed: isActive
                      ? () {
                          // Join meeting will be implemented
                          // with WebRTC later.
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5FEF),
                    disabledBackgroundColor:
                        const Color(0xFFC7C8CE),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Join Now' : 'Join',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
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
          activeIcon: Icon(Icons.calendar_month),
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
    );
  }
}