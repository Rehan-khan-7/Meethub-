import '../../../models/room.dart';

class RoomRepository {
  static final List<Room> _rooms = [];

  Future<List<Room>> getRooms(String workspaceId) async {
    return _rooms
        .where((room) => room.workspaceId == workspaceId)
        .toList();
  }

  Future<Room> createRoom({
    required String workspaceId,
    required String name,
    required String description,
    required String type,
  }) async {
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

  Future<void> deleteRoom(String roomId) async {
    _rooms.removeWhere((room) => room.id == roomId);
  }
}