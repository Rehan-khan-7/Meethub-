import 'package:flutter/material.dart';

import 'room_workspace_screen.dart';
import '../../../models/room.dart';
import '../../../widgets/deskverse_header.dart';

class RoomScreen extends StatelessWidget {
  final Room room;

  const RoomScreen({super.key, required this.room});

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
                                  room.name,
                                  style: const TextStyle(
                                    color: Color(0xFF202538),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  room.type.isEmpty ? 'General' : room.type,
                                  style: const TextStyle(
                                    color: Color(0xFF777E91),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
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
                        room.description.isEmpty
                            ? 'No description added.'
                            : room.description,
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
                      child: room.members.isEmpty
                          ? const Text(
                              'No people in this room yet.',
                              style: TextStyle(
                                color: Color(0xFF777E91),
                                fontSize: 13,
                              ),
                            )
                          : Column(
                              children: room.members.map((member) {
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
                                  RoomWorkspaceScreen(room: room),
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
