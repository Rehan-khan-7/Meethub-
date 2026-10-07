import 'package:flutter/material.dart';

import '../data/analytics_repository.dart';

class AnalyticsScreen extends StatefulWidget {
  final String workspaceId;

  const AnalyticsScreen({super.key, this.workspaceId = 'local-workspace'});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _UsageTrendPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;

  _UsageTrendPainter({required this.values, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF2879D8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFEAF3FF)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFE8EDF2)
      ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 0; i < 4; i++) {
      final y = size.height * i / 3;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.length == 1) {
      final y = size.height - (values.first / maxValue) * size.height;

      final point = Offset(size.width / 2, y);

      canvas.drawCircle(point, 5, Paint()..color = const Color(0xFF2879D8));

      return;
    }

    final points = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);

      final normalized = values[i] / maxValue;

      final y = size.height - normalized * size.height;

      points.add(Offset(x, y));
    }

    // Area below line
    final areaPath = Path()..moveTo(points.first.dx, size.height);

    for (final point in points) {
      areaPath.lineTo(point.dx, point.dy);
    }

    areaPath.lineTo(points.last.dx, size.height);

    areaPath.close();

    canvas.drawPath(areaPath, fillPaint);

    // Line
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(linePath, paint);

    // Points
    final pointPaint = Paint()
      ..color = const Color(0xFF2879D8)
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 3.5, pointPaint);

      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _UsageTrendPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.maxValue != maxValue;
  }
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsRepository analyticsRepository = AnalyticsRepository();

  Map<String, dynamic> analytics = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final data = await analyticsRepository.getAnalytics(widget.workspaceId);

      if (!mounted) return;

      setState(() {
        analytics = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Analytics error: $e');

      if (!mounted) return;

      setState(() {
        analytics = {};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalMeetingMinutes = analytics['totalMeetingMinutes'] ?? 0;

    final activeUsers = analytics['activeUsers'] ?? 0;

    final averageMeetingDuration = analytics['averageMeetingDuration'] ?? 0;

    final engagementScore = analytics['engagementScore'] ?? 0;

    final usageTrends =
        (analytics['usageTrends'] ?? []) as List<Map<String, dynamic>>;

    final topRooms =
        (analytics['topRooms'] ?? []) as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF14263D),
        elevation: 0,

        title: const Text(
          'Analytics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF14263D),
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE1E5EA)),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workspace Analytics',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14263D),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Insights into your workspace activity and engagement.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                    ),

                    const SizedBox(height: 22),

                    // =========================
                    // STAT CARDS
                    // =========================
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Total Meeting Minutes',
                            value: totalMeetingMinutes.toString(),
                            icon: Icons.access_time_rounded,
                            iconColor: const Color(0xFF2879D8),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildStatCard(
                            title: 'Active Users',
                            value: activeUsers.toString(),
                            icon: Icons.people_outline,
                            iconColor: const Color(0xFF3FA3A3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Average Meeting Duration',
                            value: '$averageMeetingDuration mins',
                            icon: Icons.timer_outlined,
                            iconColor: const Color(0xFF8B5CF6),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildStatCard(
                            title: 'Engagement Score',
                            value: '$engagementScore%',
                            icon: Icons.insights_outlined,
                            iconColor: const Color(0xFF22A06B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // =========================
                    // PLATFORM USAGE TRENDS
                    // =========================
                    _buildSectionTitle('Platform Usage Trends'),

                    const SizedBox(height: 10),

                    _buildUsageTrendCard(usageTrends),

                    const SizedBox(height: 24),

                    // =========================
                    // TOP ROOMS
                    // =========================
                    _buildSectionTitle('Top Rooms by Usage'),

                    const SizedBox(height: 10),

                    _buildTopRoomsCard(topRooms),

                    const SizedBox(height: 24),

                    // =========================
                    // ENGAGEMENT SCORE
                    // =========================
                    _buildSectionTitle('Engagement Score'),

                    const SizedBox(height: 10),

                    _buildEngagementCard(engagementScore),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8E0DA)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14263D),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFF14263D),
      ),
    );
  }

  Widget _buildUsageTrendCard(List<Map<String, dynamic>> trends) {
    if (trends.isEmpty) {
      return _buildEmptyCard('No meeting activity yet.');
    }

    final values = trends
        .map((item) => (item['value'] as num).toDouble())
        .toList();

    final maxValue = values.isEmpty
        ? 1.0
        : values.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      height: 210,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E0DA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meetings by day',
            style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: CustomPaint(
              painter: _UsageTrendPainter(
                values: values,
                maxValue: maxValue == 0 ? 1 : maxValue,
              ),
              child: const SizedBox.expand(),
            ),
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: trends.map((item) {
              return Text(
                item['day'].toString(),
                style: const TextStyle(fontSize: 10, color: Color(0xFF718096)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRoomsCard(List<Map<String, dynamic>> rooms) {
    if (rooms.isEmpty) {
      return _buildEmptyCard('No room usage data yet.');
    }

    final maxUsage = rooms.fold<int>(0, (max, room) {
      final usage = room['usage'] as int;

      return usage > max ? usage : max;
    });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E0DA)),
      ),

      child: Column(
        children: rooms.take(5).map((room) {
          final usage = room['usage'] as int;
          final String sessionText = usage == 1 ? 'session' : 'sessions';
          final ratio = maxUsage == 0 ? 0.0 : usage / maxUsage;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        room['roomName'].toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF14263D),
                        ),
                      ),
                    ),

                    Text(
                      '$usage $sessionText',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE9EDF2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2879D8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEngagementCard(int score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFE8F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0E8E8)),
      ),

      child: Row(
        children: [
          SizedBox(
            width: 105,
            height: 105,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 92,
                  height: 92,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF3FA3A3),
                    ),
                  ),
                ),

                Text(
                  '$score%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14263D),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Workspace Engagement',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF14263D),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  score == 0
                      ? 'No engagement data yet.'
                      : 'Current engagement score is $score%.',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF718096),
                  ),
                ),

                const SizedBox(height: 12),

                _buildLegend('Task completion', const Color(0xFF3FA3A3)),

                const SizedBox(height: 7),

                _buildLegend('Workspace activity', const Color(0xFF2879D8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 7),

        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Color(0xFF718096)),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E0DA)),
      ),

      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Color(0xFF718096), fontSize: 12),
        ),
      ),
    );
  }
}
