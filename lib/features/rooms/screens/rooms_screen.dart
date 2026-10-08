import 'package:flutter/material.dart';

import '../../../widgets/deskverse_bottom_nav.dart';
import 'room_screen.dart';
import '../../../models/user.dart';
import '../../../models/room.dart';
import '../../../widgets/deskverse_header.dart';
import '../data/room_repository.dart';
import 'create_room_screen.dart';
import '../../meetings/screens/meetings_screen.dart';

class RoomsScreen extends StatefulWidget {
  final User user;
  final String? workspaceId;

  const RoomsScreen({super.key, required this.user, this.workspaceId});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final TextEditingController searchController = TextEditingController();
  final RoomRepository roomRepository = RoomRepository();

  List<Room> rooms = [];
  List<Room> filteredRooms = [];

  bool isLoading = true;

  // Temporary local workspace context.
  // Later this will come from the Go backend.
  late String currentWorkspaceId;

  @override
  void initState() {
    super.initState();

    currentWorkspaceId = widget.workspaceId ?? 'local-workspace';

    searchController.addListener(_filterRooms);

    loadRooms();
  }

  Future<void> loadRooms() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await roomRepository.getRooms(currentWorkspaceId);

      if (!mounted) return;

      setState(() {
        rooms = data;
        filteredRooms = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Room loading error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterRooms() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredRooms = rooms;
      } else {
        filteredRooms = rooms.where((room) {
          return room.name.toLowerCase().contains(query) ||
              room.type.toLowerCase().contains(query) ||
              room.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _createRoom() async {
    final Room? createdRoom = await Navigator.push<Room>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoomScreen(workspaceId: currentWorkspaceId),
      ),
    );

    if (createdRoom == null || !mounted) return;

    setState(() {
      rooms.insert(0, createdRoom);
      filteredRooms = rooms;
    });
  }

  Future<void> _openRoom(Room room) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => RoomScreen(room: room)),
    );

    if (deleted == true && mounted) {
      await loadRooms();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : rooms.isEmpty
                  ? _buildEmptyRooms()
                  : _buildRoomsContent(),
            ),
          ],
        ),
      ),

      bottomNavigationBar: DeskVerseBottomNav(
        currentIndex: 1,
        user: widget.user,
        workspaceId: currentWorkspaceId,
      ),
    );
  }

  Widget _buildEmptyRooms() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),

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

                _createRoomButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Column(
            children: [
              _buildTitleRow(),

              const SizedBox(height: 14),

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search rooms...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF777E91),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: filteredRooms.isEmpty
              ? const Center(
                  child: Text(
                    'No rooms found',
                    style: TextStyle(color: Color(0xFF777E91)),
                  ),
                )
              : _buildRoomsList(filteredRooms),
        ),
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
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
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F1F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${rooms.length} ${rooms.length == 1 ? 'room' : 'rooms'}',
            style: const TextStyle(color: Color(0xFF73798B), fontSize: 12),
          ),
        ),

        const SizedBox(width: 8),

        SizedBox(
          height: 38,
          child: ElevatedButton.icon(
            onPressed: _createRoom,
            icon: const Icon(Icons.add, size: 17),
            label: const Text(
              'Add',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D5FEF),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createRoomButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _createRoom,
        icon: const Icon(Icons.add, size: 21),
        label: const Text(
          'Create Room',
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

  Widget _buildRoomsList(List<Room> rooms) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3E6EE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF3FF),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.meeting_room_outlined,
                      color: Color(0xFF2D5FEF),
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(
                            color: Color(0xFF202538),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          room.type.isEmpty ? 'General room' : room.type,
                          style: const TextStyle(
                            color: Color(0xFF777E91),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
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

              const SizedBox(height: 18),

              const Text(
                'PEOPLE IN ROOM',
                style: TextStyle(
                  color: Color(0xFF8A90A0),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),

              const SizedBox(height: 9),

              if (room.members.isEmpty)
                const Text(
                  'No people in this room',
                  style: TextStyle(color: Color(0xFF777E91), fontSize: 12),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.members.map((member) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        member,
                        style: const TextStyle(
                          color: Color(0xFF4D5365),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _openRoom(room),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2D5FEF),
                    side: const BorderSide(color: Color(0xFFD6DDF5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Open Room →',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
