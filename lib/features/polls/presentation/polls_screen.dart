import 'package:flutter/material.dart';

import '../data/poll_repository.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  int selectedDay = 0;
  int selectedCuisine = 0;
  final PollRepository pollRepository = PollRepository();

  @override
  Widget build(BuildContext context) {
    final polls = pollRepository.getPolls();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF202431),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Engagement Hub',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroTitle(),

                    const SizedBox(height: 24),

                    _buildSectionHeader(
                      'My Active Polls',
                      '${polls.length} active',
                    ),

                    const SizedBox(height: 12),

                    ...polls
                        .where((poll) => poll['status'] == 'active')
                        .map(
                          (poll) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPollCard(poll: poll),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildPollCard({required Map<String, dynamic> poll}) {
    final options = poll['options'] as List<dynamic>;
    final selectedOption = poll['selectedOption'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E5EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poll['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF14263D),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Created by ${poll['createdBy']} · '
            '${poll['votes']} votes · '
            'Closes in ${poll['closesIn']}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
          ),

          const SizedBox(height: 16),

          Text(
            poll['question'],
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF293241),
            ),
          ),

          const SizedBox(height: 12),

          ...List.generate(options.length, (index) {
            final option = options[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  pollRepository.vote(poll['id'], index);
                });
              },
              child: _buildOption(
                text: option['text'],
                votes: option['votes'],
                selected: selectedOption == index,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String text,
    required int votes,
    required bool selected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAF0FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? const Color(0xFF2864E8) : Colors.white,
              border: Border.all(
                color: selected
                    ? const Color(0xFF2864E8)
                    : const Color(0xFF9DA5B5),
              ),
            ),
            child: selected
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF252A38),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '$votes%',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 92,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFF202431),
      child: Row(
        children: [
          const Icon(Icons.layers_outlined, color: Colors.white, size: 34),

          const SizedBox(width: 12),

          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DeskVerse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Acme Corp HQ⌄',
                style: TextStyle(color: Color(0xFF9DA3B4), fontSize: 11),
              ),
            ],
          ),

          const Spacer(),

          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFDCE4ED),
            child: Icon(Icons.person, color: Color(0xFF202431)),
          ),

          const SizedBox(width: 14),

          const Icon(Icons.menu, color: Colors.white, size: 25),
        ],
      ),
    );
  }

  // ============================================================
  // HERO TITLE
  // ============================================================

  Widget _buildHeroTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Engagement Hub',
          style: TextStyle(
            color: Color(0xFF202431),
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 4),

        Text(
          'A little connection goes a long way.',
          style: TextStyle(color: Color(0xFF7B8293), fontSize: 14),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader(String title, String trailing) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF202431),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        Text(
          trailing,
          style: const TextStyle(color: Color(0xFF7B8293), fontSize: 12),
        ),
      ],
    );
  }
}
