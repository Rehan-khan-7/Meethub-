import '../../../models/meeting.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';

import 'package:flutter/foundation.dart';

class MeetingRepository {
  static final List<Meeting> _meetings = [];

  final ApiClient apiClient = ApiClient();

  static const bool useBackend = true;

  Future<List<Meeting>> getMeetings(String workspaceId) async {
    if (!useBackend) {
      return _meetings
          .where((meeting) => meeting.workspaceId == workspaceId)
          .toList();
    }

    final response = await apiClient.get(ApiConfig.meetings(workspaceId));

    if (response == null) {
      return [];
    }

    final List<dynamic> data = response as List<dynamic>;

    return data.map((json) => Meeting.fromJson(json)).toList();
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
      // existing local code...
    }

    final body = {
      'workspaceId': workspaceId,
      'roomId': roomId,
      'title': title,
      'description': description,
      'participants': [],
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
    };

    debugPrint('CREATE MEETING BODY: $body');

    final response = await apiClient.post(ApiConfig.createMeeting(), body);

    debugPrint('CREATE MEETING RESPONSE: $response');

    return Meeting.fromJson(response);
  }

  Future<void> deleteMeeting(String meetingId) async {
    if (!useBackend) {
      _meetings.removeWhere((meeting) => meeting.id == meetingId);
      return;
    }

    await apiClient.delete(ApiConfig.meeting(meetingId));
  }
}
