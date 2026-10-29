/// One line of the local leaderboard.
class LeaderboardEntry {
  const LeaderboardEntry({required this.initials, required this.score, required this.date, this.accuracy = 0});

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
    initials: json['initials'] as String? ?? '???',
    score: (json['score'] as num?)?.toInt() ?? 0,
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
    accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
  );

  final String initials;
  final int score;
  final DateTime date;

  /// Hits / shots, 0–1.
  final double accuracy;

  Map<String, dynamic> toJson() => {
    'initials': initials,
    'score': score,
    'date': date.toIso8601String(),
    'accuracy': accuracy,
  };
}

/// Where finished rounds are recorded.
abstract interface class LeaderboardRepository {
  /// Best first, at most [LocalLeaderboard.capacity] entries.
  Future<List<LeaderboardEntry>> top();

  /// Whether [score] would make it onto the board (worth asking for initials).
  Future<bool> qualifies(int score);

  /// Adds an entry; returns its 0-based rank, or null if it did not make it.
  Future<int?> add(LeaderboardEntry entry);
}
