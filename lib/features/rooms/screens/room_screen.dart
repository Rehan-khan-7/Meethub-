import 'package:flutter/material.dart';

import '../data/room_repository.dart';
import 'edit_room_screen.dart';
import 'room_workspace_screen.dart';
import '../../../models/room.dart';
import '../../../widgets/deskverse_header.dart';

class RoomScreen extends StatefulWidget {
  final Room room;

  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

//const RoomScreen({super.key, required this.room});

class _RoomScreenState extends State<RoomScreen> {
  late Room currentRoom;

  @override
  void initState() {
    super.initState();
    currentRoom = widget.room;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: SafeArea(
        child: Column(
          children: [
            const DeskVerseHeader(workspaceName: 'Acme Corp HQ'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF202538),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Room header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E3EB)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF0FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.meeting_room_outlined,
                              color: Color(0xFF2D5FEF),
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentRoom.name,
                                  style: const TextStyle(
                                    color: Color(0xFF202538),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  currentRoom.type.isEmpty
                                      ? 'General'
                                      : currentRoom.type,
                                  style: const TextStyle(
                                    color: Color(0xFF777E91),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xFF777E91),
                            ),
                            onSelected: (value) async {
                              if (value == 'edit') {
                                final updatedRoom = await Navigator.push<Room>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditRoomScreen(room: currentRoom),
                                  ),
                                );

                                if (updatedRoom != null && mounted) {
                                  setState(() {
                                    currentRoom = updatedRoom;
                                  });
                                }
                              }

                              if (value == 'delete') {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),

                                      title: const Text(
                                        'Delete Room?',
                                        style: TextStyle(
                                          color: Color(0xFF202538),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),

                                      content: Text(
                                        'Are you sure you want to delete "${currentRoom.name}"?',
                                        style: const TextStyle(
                                          color: Color(0xFF777E91),
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),

                                      actionsPadding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        20,
                                        18,
                                      ),

                                      actions: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(
                                              0xFF2D5FEF,
                                            ),
                                            side: const BorderSide(
                                              color: Color(0xFF2D5FEF),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),

                                        const SizedBox(width: 8),

                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF2D5FEF,
                                            ),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmed != true) return;

                                try {
                                  final roomRepository = RoomRepository();

                                  await roomRepository.deleteRoom(
                                    currentRoom.id,
                                  );

                                  if (!mounted) return;

                                  Navigator.pop(context, true);
                                } catch (e) {
                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to delete room: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 20),
                                    SizedBox(width: 10),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF8EF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Color(0xFF279653),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description
                    _sectionCard(
                      title: 'DESCRIPTION',
                      child: Text(
                        currentRoom.description.isEmpty
                            ? 'No description added.'
                            : currentRoom.description,
                        style: const TextStyle(
                          color: Color(0xFF4D5365),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Members
                    _sectionCard(
                      title: 'PEOPLE IN ROOM',
                      child: currentRoom.members.isEmpty
                          ? const Text(
                              'No people in this room yet.',
                              style: TextStyle(
                                color: Color(0xFF777E91),
                                fontSize: 13,
                              ),
                            )
                          : Column(
                              children: currentRoom.members.map((member) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
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
                                  title: Text(
                                    member,
                                    style: const TextStyle(
                                      color: Color(0xFF202538),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Enter Room
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RoomWorkspaceScreen(room: currentRoom),
                            ),
                          );
                        },
                        icon: const Icon(Icons.login),
                        label: const Text(
                          'Enter Room',
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
                            borderRadius: BorderRadius.circular(11),
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
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8A90A0),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
