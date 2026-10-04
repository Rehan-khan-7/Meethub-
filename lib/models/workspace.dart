class Workspace {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final List<String> members;

  Workspace({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.members,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ownerId: json['ownerId'] ?? '',
      members: List<String>.from(json['members'] ?? []),
    );
  }
}