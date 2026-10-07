import '../../../models/room.dart';
import '../../../config/api_config.dart';
import '../../../core/network/api_client.dart';

class RoomRepository {
  static final List<Room> _rooms = [];

  final ApiClient apiClient = ApiClient();

  // Backend available hone par true karna.
  static const bool useBackend = false;

  Future<List<Room>> getRooms(String workspaceId) async {
    if (!useBackend) {
      return _rooms.where((room) => room.workspaceId == workspaceId).toList();
    }

    final response = await apiClient.get(ApiConfig.rooms(workspaceId));

    final List<dynamic> data = response as List<dynamic>;

    return data.map((json) => Room.fromJson(json)).toList();
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

    return Room.fromJson(response);
  }

  Future<void> deleteRoom(String roomId) async {
    if (!useBackend) {
      _rooms.removeWhere((room) => room.id == roomId);
      return;
    }

    await apiClient.delete(ApiConfig.room(roomId));
  }
}
