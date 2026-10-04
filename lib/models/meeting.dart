class Meeting {
  final String id;
  final String workspaceId;
  final String roomId;
  final String title;
  final String description;
  final String createdBy;
  final List<String> participants;
  final DateTime startTime;
  final DateTime endTime;
  final String meetingCode;
  final String meetingLink;
  final String status;

  Meeting({
    required this.id,
    required this.workspaceId,
    required this.roomId,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.participants,
    required this.startTime,
    required this.endTime,
    required this.meetingCode,
    required this.meetingLink,
    required this.status,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] ?? '',
      workspaceId: json['workspaceId'] ?? '',
      roomId: json['roomId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['createdBy'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      meetingCode: json['meetingCode'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      status: json['status'] ?? 'scheduled',
    );
  }
}