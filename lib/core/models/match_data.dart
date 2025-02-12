class MatchData {
  final String id;
  final String userId;
  final bool won;
  final int durationInSeconds;
  final DateTime date;

  MatchData({
    required this.id,
    required this.userId,
    required this.won,
    required this.durationInSeconds,
    required this.date,
  });
}
