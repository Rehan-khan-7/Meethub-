class ApiConfig {
  static const String baseUrl = 'https://vow-5k2g.onrender.com';

  static String workspaces() {
    return '$baseUrl/api/workspaces';
  }

  static String rooms(String workspaceId) {
    return '$baseUrl/api/workspaces/$workspaceId/rooms';
  }

  static String room(String roomId) {
    return '$baseUrl/api/rooms/$roomId';
  }

  static String meetings(String workspaceId) {
    return '$baseUrl/api/meetings?workspaceId=$workspaceId';
  }

  static String meeting(String meetingId) {
    return '$baseUrl/api/meetings/$meetingId';
  }

  static String createMeeting() {
    return '$baseUrl/api/meetings';
  }
}
