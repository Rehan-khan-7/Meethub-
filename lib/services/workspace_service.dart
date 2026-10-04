import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/workspace.dart';

class WorkspaceService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Workspace>> getWorkspaces() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/workspaces',
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
            (json) => Workspace.fromJson(json),
          )
          .toList();
    }

    throw Exception(
      'Failed to load workspaces: ${response.statusCode}',
    );
  }

  Future<Workspace> createWorkspace(
    String name,
    String description,
  ) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/workspaces',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return Workspace.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create workspace: ${response.statusCode}',
    );
  }
}