import '../../../models/meeting.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';

class MeetingRepository {
  static final List<Meeting> _meetings = [];

  final ApiClient apiClient = ApiClient();

  static const bool useBackend = false;

  Future<List<Meeting>> getMeetings(String workspaceId) async {
    if (!useBackend) {
      return _meetings
          .where((meeting) => meeting.workspaceId == workspaceId)
          .toList();
    }

    final response = await apiClient.get(
      ApiConfig.meetings(workspaceId),
    );

    final List<dynamic> data = response as List<dynamic>;

    return data
        .map((json) => Meeting.fromJson(json))
        .toList();
  }

  Future<Meeting> createMeeting({
    required String workspaceId,
    required String roomId,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (!useBackend) {
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
        meetingCode:
            'MEET-${DateTime.now().millisecondsSinceEpoch}',
        meetingLink: '',
        status: 'scheduled',
      );

      _meetings.add(meeting);

      return meeting;
    }

    final response = await apiClient.post(
      ApiConfig.createMeeting(),
      {
        'workspaceId': workspaceId,
        'roomId': roomId,
        'title': title,
        'description': description,
        'participants': [],
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      },
    );

    return Meeting.fromJson(response);
  }

  Future<void> deleteMeeting(String meetingId) async {
    if (!useBackend) {
      _meetings.removeWhere(
        (meeting) => meeting.id == meetingId,
      );
      return;
    }

    await apiClient.delete(
      ApiConfig.meeting(meetingId),
    );
  }
}