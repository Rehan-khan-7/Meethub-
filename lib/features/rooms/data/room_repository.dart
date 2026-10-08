import '../../../models/room.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';

import 'package:flutter/foundation.dart';

class RoomRepository {
  static final List<Room> _rooms = [];

  final ApiClient apiClient = ApiClient();

  // Backend available hone par true karna.
  static const bool useBackend = true;

  Future<List<Room>> getRooms(String workspaceId) async {
    try {
      final response = await apiClient.get(ApiConfig.rooms(workspaceId));

      print('GET ROOMS RESPONSE: $response');

      if (response == null) {
        return [];
      }

      final List<dynamic> data = response as List<dynamic>;

      final rooms = data.map((json) {
        print('ROOM JSON: $json');
        return Room.fromJson(json as Map<String, dynamic>);
      }).toList();

      print('PARSED ROOMS: ${rooms.length}');

      return rooms;
    } catch (e, stackTrace) {
      print('GET ROOMS ERROR: $e');
      print(stackTrace);
      rethrow;
    }
  }

  Future<Room> createRoom({
    required String workspaceId,
    required String name,
    required String description,
    required String type,
  }) async {
    if (!useBackend) {
      final room = Room(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workspaceId: workspaceId,
        name: name,
        description: description,
        type: type,
        createdBy: 'test-user',
        members: const [],
      );

      _rooms.add(room);

      return room;
    }

    final response = await apiClient.post(ApiConfig.rooms(workspaceId), {
      'name': name,
      'description': description,
      'type': type,
    });

    debugPrint('CREATE ROOM RESPONSE: $response');

    if (response == null) {
      throw Exception('Create room returned null response');
    }

    return Room.fromJson(response);
  }

  Future<Room> updateRoom({
    required String roomId,
    required String name,
    required String description,
    required String type,
  }) async {
    if (!useBackend) {
      final index = _rooms.indexWhere((room) => room.id == roomId);

      if (index == -1) {
        throw Exception('Room not found');
      }

      final oldRoom = _rooms[index];

      final updatedRoom = Room(
        id: oldRoom.id,
        workspaceId: oldRoom.workspaceId,
        name: name,
        description: description,
        type: type,
        createdBy: oldRoom.createdBy,
        members: oldRoom.members,
      );

      _rooms[index] = updatedRoom;

      return updatedRoom;
    }

    final response = await apiClient.put(ApiConfig.room(roomId), {
      'name': name,
      'description': description,
      'type': type,
    });

    debugPrint('UPDATE ROOM RESPONSE: $response');

    if (response == null) {
      throw Exception('Update room returned null response');
    }

    // Backend only returns {"status": "updated"}.
    // Fetch the updated room again.
    final updatedResponse = await apiClient.get(ApiConfig.room(roomId));

    debugPrint('UPDATED ROOM FETCH RESPONSE: $updatedResponse');

    if (updatedResponse == null) {
      throw Exception('Updated room could not be fetched');
    }

    return Room.fromJson(updatedResponse as Map<String, dynamic>);
  }

  Future<void> deleteRoom(String roomId) async {
    if (!useBackend) {
      _rooms.removeWhere((room) => room.id == roomId);
      return;
    }

    await apiClient.delete(ApiConfig.room(roomId));
  }
}
