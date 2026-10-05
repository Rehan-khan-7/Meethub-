import '../../../models/meeting.dart';
import 'package:flutter/foundation.dart';
class MeetingRepository {
  static final List<Meeting> _meetings = [];

  Future<List<Meeting>> getMeetings(String workspaceId) async {
    return _meetings
        .where((meeting) => meeting.workspaceId == workspaceId)
        .toList();
  }

  Future<void> deleteMeeting(String meetingId) async {

    _meetings.removeWhere((meeting) => meeting.id == meetingId);

  }

  Future<Meeting> createMeeting({
    required String workspaceId,
    required String roomId,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final meeting = Meeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workspaceId: workspaceId,
      roomId: roomId,
      title: title,
      description: description,
      createdBy: 'test-user',
      participants: const [],
      startTime: startTime,
      endTime: endTime,
      meetingCode: 'MEET-${DateTime.now().millisecondsSinceEpoch}',
      meetingLink: '',
      status: 'scheduled',
    );

    _meetings.add(meeting);

    return meeting;
  }
}
