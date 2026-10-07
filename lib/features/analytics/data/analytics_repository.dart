import '../../../models/meeting.dart';
import '../../../models/room.dart';
import '../../meetings/data/meeting_repository.dart';
import '../../rooms/data/room_repository.dart';
import '../../tasks/data/task_repository.dart';

class AnalyticsRepository {
  final MeetingRepository meetingRepository = MeetingRepository();
  final RoomRepository roomRepository = RoomRepository();
  final TaskRepository taskRepository = TaskRepository();

  Future<Map<String, dynamic>> getAnalytics(
    String workspaceId,
  ) async {
    final meetings =
        await meetingRepository.getMeetings(workspaceId);

    final rooms =
        await roomRepository.getRooms(workspaceId);

    final tasks =
        taskRepository.getTasks();

    return {
      'totalMeetingMinutes':
          _calculateTotalMeetingMinutes(meetings),

      'activeUsers':
          _calculateActiveUsers(rooms, meetings),

      'averageMeetingDuration':
          _calculateAverageMeetingDuration(meetings),

      'usageTrends':
          _calculateUsageTrends(meetings),

      'topRooms':
          _calculateTopRooms(rooms, meetings),

      'engagementScore':
          _calculateEngagementScore(tasks),

      'totalMeetings':
          meetings.length,

      'totalRooms':
          rooms.length,

      'totalTasks':
          tasks.length,

      'completedTasks':
          tasks.where(
            (task) => task['completed'] == true,
          ).length,
    };
  }

  int _calculateTotalMeetingMinutes(
    List<Meeting> meetings,
  ) {
    int totalMinutes = 0;

    for (final meeting in meetings) {
      final duration =
          meeting.endTime.difference(
        meeting.startTime,
      ).inMinutes;

      if (duration > 0) {
        totalMinutes += duration;
      }
    }

    return totalMinutes;
  }

  int _calculateActiveUsers(
    List<Room> rooms,
    List<Meeting> meetings,
  ) {
    final users = <String>{};

    // Users present in rooms
    for (final room in rooms) {
      users.addAll(room.members);
    }

    // Users participating in meetings
    for (final meeting in meetings) {
      users.addAll(meeting.participants);

      if (meeting.createdBy.isNotEmpty) {
        users.add(meeting.createdBy);
      }
    }

    return users.length;
  }

  int _calculateAverageMeetingDuration(
    List<Meeting> meetings,
  ) {
    if (meetings.isEmpty) {
      return 0;
    }

    final totalMinutes =
        _calculateTotalMeetingMinutes(meetings);

    return (totalMinutes / meetings.length).round();
  }

  List<Map<String, dynamic>> _calculateUsageTrends(
    List<Meeting> meetings,
  ) {
    final days = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final counts = <String, int>{
      for (final day in days) day: 0,
    };

    for (final meeting in meetings) {
      final weekday =
          days[meeting.startTime.weekday - 1];

      counts[weekday] =
          (counts[weekday] ?? 0) + 1;
    }

    return days.map((day) {
      return {
        'day': day,
        'value': counts[day] ?? 0,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _calculateTopRooms(
    List<Room> rooms,
    List<Meeting> meetings,
  ) {
    final roomUsage = <String, int>{};

    for (final meeting in meetings) {
      roomUsage[meeting.roomId] =
          (roomUsage[meeting.roomId] ?? 0) + 1;
    }

    final result = <Map<String, dynamic>>[];

    for (final room in rooms) {
      result.add({
        'roomId': room.id,
        'roomName': room.name,
        'usage': roomUsage[room.id] ?? 0,
      });
    }

    result.sort(
      (a, b) =>
          (b['usage'] as int)
              .compareTo(a['usage'] as int),
    );

    return result;
  }

  int _calculateEngagementScore(
    List<Map<String, dynamic>> tasks,
  ) {
    if (tasks.isEmpty) {
      return 0;
    }

    final completedTasks =
        tasks.where(
          (task) => task['completed'] == true,
        ).length;

    return (
      completedTasks /
      tasks.length *
      100
    ).round();
  }
}