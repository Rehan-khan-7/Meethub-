import 'package:flutter/material.dart';

import '../../../models/room.dart';
import '../data/room_repository.dart';

class EditRoomScreen extends StatefulWidget {
  final Room room;

  const EditRoomScreen({super.key, required this.room});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final RoomRepository roomRepository = RoomRepository();

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController typeController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.room.name);
    descriptionController = TextEditingController(
      text: widget.room.description,
    );
    typeController = TextEditingController(text: widget.room.type);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    typeController.dispose();
    super.dispose();
  }

  Future<void> saveRoom() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room name cannot be empty')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final updatedRoom = await roomRepository.updateRoom(
        roomId: widget.room.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        type: typeController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, updatedRoom);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update room: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Room',
          style: TextStyle(
            color: Color(0xFF202538),
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF202538)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Room Name',
              style: TextStyle(
                color: Color(0xFF202538),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter room name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(
                color: Color(0xFF202538),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter room description',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Room Type',
              style: TextStyle(
                color: Color(0xFF202538),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: typeController.text.isEmpty
                  ? 'general'
                  : typeController.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'general', child: Text('General')),
                DropdownMenuItem(value: 'meeting', child: Text('Meeting')),
                DropdownMenuItem(value: 'team', child: Text('Team')),
              ],
              onChanged: (value) {
                if (value != null) {
                  typeController.text = value;
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5FEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
