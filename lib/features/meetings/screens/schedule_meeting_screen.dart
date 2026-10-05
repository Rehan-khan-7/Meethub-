import 'package:flutter/material.dart';

import '../../../models/room.dart';
import '../../rooms/data/room_repository.dart';
import '../../../models/meeting.dart';
import '../../../services/meeting_service.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  final String workspaceId;

  const ScheduleMeetingScreen({super.key, required this.workspaceId});

  @override
  State<ScheduleMeetingScreen> createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  final MeetingService meetingService = MeetingService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final RoomRepository roomRepository = RoomRepository();

  Future<void> loadRooms() async {
    try {
      final data = await roomRepository.getRooms(widget.workspaceId);

      if (!mounted) return;

      setState(() {
        rooms = data;
        isLoadingRooms = false;
      });
    } catch (e) {
      debugPrint('Room loading error: $e');

      if (!mounted) return;

      setState(() {
        isLoadingRooms = false;
      });
    }
  }

  List<Room> rooms = [];
  Room? selectedRoom;

  bool isLoadingRooms = true;

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool isCreating = false;
  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        startTime = time;
      });
    }
  }

  Future<void> selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        endTime = time;
      });
    }
  }

  DateTime? buildDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> createMeeting() async {
    if (selectedRoom == null) {
      showMessage('Select a room');
      return;
    }
    if (titleController.text.trim().isEmpty) {
      showMessage('Enter meeting title');
      return;
    }

    if (selectedDate == null) {
      showMessage('Select meeting date');
      return;
    }

    if (startTime == null) {
      showMessage('Select start time');
      return;
    }

    if (endTime == null) {
      showMessage('Select end time');
      return;
    }

    final start = buildDateTime(selectedDate!, startTime!);

    final end = buildDateTime(selectedDate!, endTime!);

    if (start == null || end == null) {
      return;
    }

    if (!end.isAfter(start)) {
      showMessage('End time must be after start time');
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      final Meeting meeting = await meetingService.createMeeting(
        workspaceId: widget.workspaceId,
        roomId: selectedRoom!.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        startTime: start,
        endTime: end,
      );

      if (!mounted) return;

      Navigator.pop(context, meeting);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isCreating = false;
      });

      showMessage('Failed to create meeting');

      debugPrint('Create meeting error: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String dateText() {
    if (selectedDate == null) {
      return 'Select date';
    }

    return '${selectedDate!.day}/'
        '${selectedDate!.month}/'
        '${selectedDate!.year}';
  }

  String timeText(TimeOfDay? time) {
    if (time == null) {
      return 'Select time';
    }

    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF202638),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Schedule Meeting',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a new meeting',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFF252A3A),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Schedule a meeting with your team.',
              style: TextStyle(color: Color(0xFF73798C), fontSize: 13),
            ),

            const SizedBox(height: 25),

            _label('Meeting title'),

            _textField(controller: titleController, hint: 'e.g. Team Standup'),

            const SizedBox(height: 18),

            _label('Description'),

            _textField(
              controller: descriptionController,
              hint: 'Add meeting description',
              maxLines: 3,
            ),

            const SizedBox(height: 18),

            _label('Room'),

            DropdownButtonFormField<Room>(
              value: selectedRoom,
              decoration: InputDecoration(
                hintText: isLoadingRooms ? 'Loading rooms...' : 'Select room',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Color(0xFFDCE0EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Color(0xFFDCE0EA)),
                ),
              ),
              items: rooms.map((room) {
                return DropdownMenuItem<Room>(
                  value: room,
                  child: Text(room.name),
                );
              }).toList(),
              onChanged: isLoadingRooms
                  ? null
                  : (room) {
                      setState(() {
                        selectedRoom = room;
                      });
                    },
            ),

            const SizedBox(height: 20),

            _label('Date'),

            _selectionButton(
              icon: Icons.calendar_month_outlined,
              text: dateText(),
              onTap: selectDate,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Start time'),

                      _selectionButton(
                        icon: Icons.access_time,
                        text: timeText(startTime),
                        onTap: selectStartTime,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('End time'),

                      _selectionButton(
                        icon: Icons.access_time,
                        text: timeText(endTime),
                        onTap: selectEndTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isCreating ? null : createMeeting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5FEF),
                  foregroundColor: Colors.white,
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
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Meeting',
                        style: TextStyle(
                          fontSize: 14,
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF252A3A),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9AA0AF), fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFDCE0EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFDCE0EA)),
        ),
      ),
    );
  }

  Widget _selectionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFDCE0EA)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: const Color(0xFF596174)),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Color(0xFF596174), fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
