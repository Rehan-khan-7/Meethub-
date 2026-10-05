import 'package:flutter/material.dart';

import '../../../models/room.dart';
//import '../../../services/room_service.dart';
import '../data/room_repository.dart';

class CreateRoomScreen extends StatefulWidget {
  final String workspaceId;

  const CreateRoomScreen({super.key, required this.workspaceId});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final RoomRepository roomRepository = RoomRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedType = 'general';
  bool isCreating = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createRoom() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a room name')));
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      final Room room = await roomRepository.createRoom(
        workspaceId: widget.workspaceId,
        name: name,
        description: description,
        type: selectedType,
      );

      if (!mounted) return;

      Navigator.pop(context, room);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to create room: $e')));

      setState(() {
        isCreating = false;
      });
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF202538),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFDCE0EA)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFDCE0EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFF2D5FEF), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF202538),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Create Room',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a new room',
              style: TextStyle(
                color: Color(0xFF202538),
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Create a space where your team can meet, work, and connect.',
              style: TextStyle(
                color: Color(0xFF777E91),
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            _label('Room Name'),

            TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('e.g. Design Team'),
            ),

            const SizedBox(height: 20),

            _label('Description'),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: _inputDecoration('Describe what this room is for'),
            ),

            const SizedBox(height: 20),

            _label('Room Type'),

            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: _inputDecoration('Select room type'),
              items: const [
                DropdownMenuItem(value: 'general', child: Text('General')),
                DropdownMenuItem(value: 'meeting', child: Text('Meeting')),
                DropdownMenuItem(value: 'team', child: Text('Team')),
              ],
              onChanged: isCreating
                  ? null
                  : (value) {
                      if (value == null) return;

                      setState(() {
                        selectedType = value;
                      });
                    },
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isCreating ? null : createRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5FEF),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF9AA4C0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: isCreating
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Room',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
