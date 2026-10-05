class Room {
  final String id;
  final String workspaceId;
  final String name;
  final String description;
  final String type;
  final String createdBy;
  final List<String> members;

  Room({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.description,
    required this.type,
    required this.createdBy,
    required this.members,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      workspaceId: json['workspaceId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      createdBy: json['createdBy'] ?? '',
      members: List<String>.from(json['members'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workspaceId': workspaceId,
      'name': name,
      'description': description,
      'type': type,
      'createdBy': createdBy,
      'members': members,
    };
  }
}