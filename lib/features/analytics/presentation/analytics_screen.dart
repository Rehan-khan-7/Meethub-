import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202431),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Workspace Analytics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workspace Overview',
              style: TextStyle(
                color: Color(0xFF14263D),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'See how your workspace is performing.',
              style: TextStyle(color: Color(0xFF718096), fontSize: 12),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Attendance',
                    value: '96%',
                    icon: Icons.people_outline,
                    iconColor: const Color(0xFF3FA3A3),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildStatCard(
                    title: 'Engagement',
                    value: 'High',
                    icon: Icons.trending_up,
                    iconColor: const Color(0xFF2879D8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Active Rooms',
                    value: '6',
                    icon: Icons.meeting_room_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildStatCard(
                    title: 'Tasks Done',
                    value: '78%',
                    icon: Icons.task_alt,
                    iconColor: const Color(0xFF22A06B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            _buildSectionTitle('Attendance'),

            const SizedBox(height: 10),

            _buildChartCard(),

            const SizedBox(height: 24),

            _buildSectionTitle('Workspace Activity'),

            const SizedBox(height: 10),

            _buildActivityCard(),

            const SizedBox(height: 24),

            _buildSectionTitle('Team Engagement'),

            const SizedBox(height: 10),

            _buildEngagementCard(),
          ],
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE4DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF14263D),
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(color: Color(0xFF718096), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF14263D),
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 210,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE4DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly attendance',
            style: TextStyle(color: Color(0xFF718096), fontSize: 12),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBar('Mon', 0.72),
                _buildBar('Tue', 0.86),
                _buildBar('Wed', 0.68),
                _buildBar('Thu', 0.94),
                _buildBar('Fri', 0.81),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${(value * 100).round()}%',
          style: const TextStyle(color: Color(0xFF718096), fontSize: 9),
        ),

        const SizedBox(height: 5),

        Container(
          width: 28,
          height: 105 * value,
          decoration: BoxDecoration(
            color: const Color(0xFF3FA3A3),
            borderRadius: BorderRadius.circular(6),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          day,
          style: const TextStyle(color: Color(0xFF718096), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE4DE)),
      ),
      child: Column(
        children: [
          _activityRow(
            Icons.meeting_room_outlined,
            'Room activity',
            '24 sessions this week',
          ),

          const Divider(height: 22),

          _activityRow(Icons.task_alt, 'Task completion', '78% completed'),

          const Divider(height: 22),

          _activityRow(
            Icons.poll_outlined,
            'Poll participation',
            '82% participation',
          ),
        ],
      ),
    );
  }

  Widget _activityRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xFF2879D8), size: 19),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF14263D),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF718096), fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0E8E8)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.insights_outlined,
            color: Color(0xFF3FA3A3),
            size: 30,
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Team engagement is high',
                  style: TextStyle(
                    color: Color(0xFF14263D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Your workspace is showing strong participation this week.',
                  style: TextStyle(color: Color(0xFF718096), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
