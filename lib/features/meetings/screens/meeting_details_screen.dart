import 'package:flutter/material.dart';

import '../data/meeting_repository.dart';
import '../../../models/meeting.dart';

class MeetingDetailsScreen extends StatelessWidget {
  final Meeting meeting;
  final String roomName;
  static MeetingRepository meetingRepository = MeetingRepository();

  const MeetingDetailsScreen({
    super.key,
    required this.meeting,
    required this.roomName,
  });

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

  String formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatDuration() {
    final minutes = meeting.endTime.difference(meeting.startTime).inMinutes;

    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;

      if (remainingMinutes == 0) {
        return '${hours}h';
      }

      return '${hours}h ${remainingMinutes}m';
    }

    return '${minutes}m';
  }

  Future<void> _deleteMeeting(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          title: const Text(
            'Delete Meeting?',
            style: TextStyle(
              color: Color(0xFF202538),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          content: const Text(
            'This meeting will be removed from your meetings.',
            style: TextStyle(
              color: Color(0xFF777E91),
              fontSize: 14,
              height: 1.4,
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2D5FEF),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF2D5FEF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                backgroundColor: const Color(0xFF2D5FEF),
                foregroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await meetingRepository.deleteMeeting(meeting.id);

    if (!context.mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF252A3A)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Meeting Details',
          style: TextStyle(
            color: Color(0xFF252A3A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFE05252)),
            onPressed: () => _deleteMeeting(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            _buildParticipantsCard(),
            const SizedBox(height: 16),
            _buildMeetingCodeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Color(0xFF73798C),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  roomName,
                  style: const TextStyle(
                    color: Color(0xFF73798C),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: meeting.status == 'active'
            ? const Color(0xFFE8F7EF)
            : const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        meeting.status.toUpperCase(),
        style: TextStyle(
          color: meeting.status == 'active'
              ? const Color(0xFF29A36A)
              : const Color(0xFF2D5FEF),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return _card(
      child: Column(
        children: [
          _infoRow(
            Icons.calendar_month_outlined,
            'Date',
            formatDate(meeting.startTime),
          ),
          const Divider(height: 24),
          _infoRow(
            Icons.access_time,
            'Time',
            '${formatTime(meeting.startTime)} – '
                '${formatTime(meeting.endTime)}',
          ),
          const Divider(height: 24),
          _infoRow(Icons.timelapse, 'Duration', formatDuration()),
          const Divider(height: 24),
          _infoRow(Icons.location_on_outlined, 'Room', roomName),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Color(0xFF252A3A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            meeting.description.isEmpty
                ? 'No description provided.'
                : meeting.description,
            style: const TextStyle(
              color: Color(0xFF73798C),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Participants',
            style: TextStyle(
              color: Color(0xFF252A3A),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            meeting.participants.isEmpty
                ? 'No participants added yet.'
                : '${meeting.participants.length} participants',
            style: const TextStyle(color: Color(0xFF73798C), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingCodeCard() {
    return _card(
      child: Row(
        children: [
          const Icon(Icons.key_outlined, color: Color(0xFF2D5FEF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meeting Code',
                  style: TextStyle(
                    color: Color(0xFF252A3A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meeting.meetingCode,
                  style: const TextStyle(
                    color: Color(0xFF73798C),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2D5FEF)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF858B9D), fontSize: 11),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF252A3A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD7DAE7)),
      ),
      child: child,
    );
  }
}
