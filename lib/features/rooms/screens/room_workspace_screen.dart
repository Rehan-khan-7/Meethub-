import 'package:flutter/material.dart';
import 'room_chat_screen.dart';
import '../../meetings/screens/meeting_lobby_screen.dart';
import '../../../models/room.dart';
import '../../../models/meeting.dart';

class RoomWorkspaceScreen extends StatefulWidget {
  final Room room;

  const RoomWorkspaceScreen({super.key, required this.room});

  @override
  State<RoomWorkspaceScreen> createState() => _RoomWorkspaceScreenState();
}

class _RoomWorkspaceScreenState extends State<RoomWorkspaceScreen> {
  bool isInsideRoom = true;

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF202538),
        foregroundColor: Colors.white,
        elevation: 0,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              isInsideRoom ? 'You are in the room' : 'You left the room',
              style: TextStyle(
                fontSize: 11,
                color: isInsideRoom
                    ? const Color(0xFFB9F2C9)
                    : const Color(0xFFD0D3DC),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Room status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: isInsideRoom
                        ? const Color(0xFF279653)
                        : const Color(0xFF8A90A0),
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  isInsideRoom ? 'Room is active' : 'You are outside',
                  style: const TextStyle(
                    color: Color(0xFF4D5365),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                Text(
                  '${room.members.length} members',
                  style: const TextStyle(
                    color: Color(0xFF777E91),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Main room area
                  Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      color: const Color(0xFF202538),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFF30384F),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.meeting_room_outlined,
                            color: Color(0xFF6D8FFF),
                            size: 36,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          room.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          room.description.isEmpty
                              ? 'Welcome to your room'
                              : room.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFB8BDCC),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Participants
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E3EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PARTICIPANTS',
                          style: TextStyle(
                            color: Color(0xFF8A90A0),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),

                        const SizedBox(height: 14),

                        if (room.members.isEmpty)
                          const Text(
                            'No other participants yet.',
                            style: TextStyle(
                              color: Color(0xFF777E91),
                              fontSize: 13,
                            ),
                          )
                        else
                          ...room.members.map(
                            (member) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: const Color(0xFFEAF0FF),
                                    child: Text(
                                      member.isEmpty
                                          ? '?'
                                          : member[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFF2D5FEF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    member,
                                    style: const TextStyle(
                                      color: Color(0xFF202538),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          icon: Icons.videocam_outlined,
                          label: 'Start Meeting',
                          onPressed: () {
                            final meeting = Meeting(
                              id: 'local-meeting',
                              workspaceId: room.workspaceId,
                              roomId: room.id,
                              title: '${room.name} Meeting',
                              description: room.description,
                              createdBy: room.createdBy,
                              participants: room.members,
                              startTime: DateTime.now(),
                              endTime: DateTime.now().add(
                                const Duration(hours: 1),
                              ),
                              meetingCode: 'LOCAL-MEETING',
                              meetingLink: '',
                              status: 'live',
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MeetingLobbyScreen(meeting: meeting),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _actionButton(
                          icon: Icons.chat_bubble_outline,
                          label: 'Chat',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RoomChatScreen(room: room),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          isInsideRoom = false;
                        });

                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Leave Room',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD64545),
                        side: const BorderSide(color: Color(0xFFE4BABA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
}
