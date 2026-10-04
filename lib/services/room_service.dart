import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/room.dart';

class RoomService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Room>> getRooms(
    String workspaceId,
  ) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/workspaces/$workspaceId/rooms',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map(
            (json) => Room.fromJson(json),
          )
          .toList();
    }

    throw Exception(
      'Failed to load rooms: ${response.statusCode}',
    );
  }

  Future<Room> createRoom({
    required String workspaceId,
    required String name,
    String description = '',
    String type = 'general',
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/workspaces/$workspaceId/rooms',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'type': type,
      }),
    );

    if (response.statusCode == 201) {
      return Room.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create room: ${response.statusCode}',
    );
  }
}