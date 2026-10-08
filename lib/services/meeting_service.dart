import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/meeting.dart';

class MeetingService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Meeting>> getMeetings(String workspaceId) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/meetings?workspaceId=$workspaceId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded == null) {
        return [];
      }

      final List data = decoded;

      return data.map((json) => Meeting.fromJson(json)).toList();
    }

    throw Exception('Failed to load meetings: ${response.statusCode}');
  }

  Future<Meeting> createMeeting({
    required String workspaceId,
    required String roomId,
    required String title,
    String description = '',
    List<String> participants = const [],
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final token = await _getToken();

    final requestBody = {
      'workspaceId': workspaceId,
      'roomId': roomId,
      'title': title,
      'description': description,
      'participants': participants,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
    };

    debugPrint('CREATE MEETING BODY: $requestBody');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/meetings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      return Meeting.fromJson(jsonDecode(response.body));
    }

    debugPrint(
      'CREATE MEETING RESPONSE: '
      '${response.statusCode} ${response.body}',
    );

    throw Exception(
      'Failed to create meeting: '
      '${response.statusCode} ${response.body}',
    );
  }
}
