class PollRepository {
  static const bool useBackend = false;

  // ============================================================
  // LOCAL POLL DATA
  // ============================================================

  static final List<Map<String, dynamic>> _polls = [
    {
      'id': 'poll-1',
      'title': 'Preferred day for Q4 All-Hands?',
      'createdBy': 'Mike',
      'votes': 45,
      'closesIn': '2 days',
      'question': 'Which day of the week works best for you?',
      'status': 'active',
      'options': [
        {
          'text': 'Wednesday',
          'votes': 62,
        },
        {
          'text': 'Thursday',
          'votes': 38,
        },
        {
          'text': 'Friday',
          'votes': 24,
        },
      ],
      'selectedOption': null,
    },
    {
      'id': 'poll-2',
      'title': 'Workspace Lunch Catering - October',
      'createdBy': 'Sarah',
      'votes': 32,
      'closesIn': '4 days',
      'question': 'What cuisine do you prefer for the monthly lunch?',
      'status': 'active',
      'options': [
        {
          'text': 'Mediterranean',
          'votes': 62,
        },
        {
          'text': 'Mexican',
          'votes': 38,
        },
        {
          'text': 'Asian Fusion',
          'votes': 24,
        },
      ],
      'selectedOption': null,
    },
  ];

  // ============================================================
  // GET POLLS
  // ============================================================

  List<Map<String, dynamic>> getPolls() {
    return _polls;
  }

  // ============================================================
  // VOTE
  // ============================================================

  void vote(String pollId, int optionIndex) {
    final poll = _polls.firstWhere(
      (poll) => poll['id'] == pollId,
    );

    final options = poll['options'] as List<dynamic>;

    final previousSelected = poll['selectedOption'];

    // Agar user same option dobara click kare
    if (previousSelected == optionIndex) {
      return;
    }

    // Agar pehle kisi option ko vote kiya tha,
    // uska vote wapas karo.
    if (previousSelected != null) {
      final previousOption =
          options[previousSelected] as Map<String, dynamic>;

      previousOption['votes'] =
          (previousOption['votes'] as int) - 1;
    } else {
      poll['votes'] = (poll['votes'] as int) + 1;
    }

    // New option me vote add karo
    final selectedOption =
        options[optionIndex] as Map<String, dynamic>;

    selectedOption['votes'] =
        (selectedOption['votes'] as int) + 1;

    poll['selectedOption'] = optionIndex;
  }

  // ============================================================
  // CREATE POLL
  // ============================================================

  void addPoll(Map<String, dynamic> poll) {
    _polls.add(poll);
  }

  // ============================================================
  // DELETE POLL
  // ============================================================

  void deletePoll(String pollId) {
    _polls.removeWhere(
      (poll) => poll['id'] == pollId,
    );
  }

  // ============================================================
  // CLOSE POLL
  // ============================================================

  void closePoll(String pollId) {
    final poll = _polls.firstWhere(
      (poll) => poll['id'] == pollId,
    );

    poll['status'] = 'closed';
  }
}