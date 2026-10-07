class PollRepository {
  static const bool useBackend = false;

  static final List<Map<String, dynamic>> _polls = [
    {
      'id': 'poll-1',
      'title': 'Preferred day for Q4 All-Hands?',
      'createdBy': 'Mike',
      'votes': 45,
      'closesIn': '2 days',
      'question': 'Which day of the week works best for you?',
      'options': [
        {'text': 'Wednesday', 'votes': 62},
        {'text': 'Thursday', 'votes': 38},
        {'text': 'Friday', 'votes': 24},
      ],
      'selectedOption': null,
      'status': 'active',
    },
    {
      'id': 'poll-2',
      'title': 'Workspace Lunch Catering - October',
      'createdBy': 'Sarah',
      'votes': 32,
      'closesIn': '4 days',
      'question': 'What cuisine do you prefer for the monthly lunch?',
      'options': [
        {'text': 'Mediterranean', 'votes': 62},
        {'text': 'Mexican', 'votes': 38},
        {'text': 'Asian Fusion', 'votes': 24},
      ],
      'selectedOption': null,
      'status': 'active',
    },
  ];

  List<Map<String, dynamic>> getPolls() {
    return _polls;
  }

  void vote(String pollId, int optionIndex) {
    final poll = _polls.firstWhere(
      (poll) => poll['id'] == pollId,
    );

    poll['selectedOption'] = optionIndex;

    final options = poll['options'] as List<dynamic>;
    final selectedOption = options[optionIndex] as Map<String, dynamic>;

    selectedOption['votes'] =
        (selectedOption['votes'] as int) + 1;

    poll['votes'] = (poll['votes'] as int) + 1;
  }

  void addPoll(Map<String, dynamic> poll) {
    _polls.add(poll);
  }

  void deletePoll(String pollId) {
    _polls.removeWhere(
      (poll) => poll['id'] == pollId,
    );
  }
}