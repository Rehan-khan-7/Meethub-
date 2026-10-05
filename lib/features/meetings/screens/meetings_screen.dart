import 'package:flutter/material.dart';

import '../../../widgets/deskverse_header.dart';
import '../../../models/meeting.dart';
import '../../../models/user.dart';

import '../../rooms/screens/rooms_screen.dart';
import 'schedule_meeting_screen.dart';
import '../data/meeting_repository.dart';

class MeetingsScreen extends StatefulWidget {
  final User user;
  final String? workspaceId;

  const MeetingsScreen({super.key, required this.user, this.workspaceId});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  final MeetingRepository meetingRepository = MeetingRepository();

  late String currentWorkspaceId;

  List<Meeting> meetings = [];

  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    currentWorkspaceId = widget.workspaceId ?? 'local-workspace';

    loadMeetings();
  }

  Future<void> loadMeetings() async {
    try {
      final data = await meetingRepository.getMeetings(currentWorkspaceId);

      if (!mounted) return;

      setState(() {
        meetings = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Meeting error: $e');

      if (!mounted) return;

      setState(() {
        meetings = [];
        isLoading = false;
      });
    }
  }


  List<Meeting> get filteredMeetings {
    if (searchQuery.trim().isEmpty) {
      return meetings;
    }

    return meetings.where((meeting) {
      return meeting.title.toLowerCase().contains(searchQuery.toLowerCase());
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

  String formatDuration(DateTime start, DateTime end) {
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
            const DeskVerseHeader(workspaceName: 'Acme Corp HQ'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
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
                    else if (filtered.isEmpty)
                      _buildEmptyMeetings()
                    else
                      ...filtered.map(
                        (meeting) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEFF8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${meetings.length} today',
            style: const TextStyle(color: Color(0xFF73798C), fontSize: 12),
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
        border: Border.all(color: const Color(0xFFDCE0EA)),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Color(0xFF73798C)),
          hintText: 'Search',
          hintStyle: TextStyle(color: Color(0xFF858B9D), fontSize: 13),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          final meeting = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ScheduleMeetingScreen(workspaceId: currentWorkspaceId),
            ),
          );
          if (meeting is Meeting) {
            setState(() {
              meetings.insert(0, meeting);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Schedule New Meeting',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD7DAE7)),
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

              const Icon(Icons.more_horiz, color: Color(0xFF7B8191)),
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
                            Colors.primaries[index % Colors.primaries.length],
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
              const Icon(Icons.access_time, size: 17, color: Color(0xFF7B8191)),

              const SizedBox(width: 7),

              Text(
                'Today, ${formatTime(meeting.startTime)} – '
                '${formatTime(meeting.endTime)} '
                '(${formatDuration(meeting.startTime, meeting.endTime)})',
                style: const TextStyle(color: Color(0xFF73798C), fontSize: 12),
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
                style: TextStyle(color: Color(0xFF73798C), fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              if (isActive) ...[
                const Icon(Icons.circle, size: 7, color: Color(0xFF29A36A)),

                const SizedBox(width: 5),

                const Text(
                  'Recurring (Weekly)',
                  style: TextStyle(color: Color(0xFF29A36A), fontSize: 11),
                ),
              ] else
                const Text(
                  'Not started',
                  style: TextStyle(color: Color(0xFF7B8191), fontSize: 11),
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
                    disabledBackgroundColor: const Color(0xFFC7C8CE),
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

      // 👇 YAHAN ADD KARO
      onTap: (index) {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
          return;
        }

        if (index == 1) {
          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomsScreen(
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

Widget _buildEmptyMeetings() {
  return SizedBox(
    width: double.infinity,
    height: 520,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 112,
          height: 112,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF0FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 52,
            color: Color(0xFF2860F5),
          ),
        ),

        const SizedBox(height: 26),

        const Text(
          'No meetings yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF252A3A),
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Your calendar is clear. When you’re ready, '
            'schedule a meeting to bring your team together.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF7A8193),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
