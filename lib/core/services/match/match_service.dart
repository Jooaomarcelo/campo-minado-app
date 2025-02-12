import 'package:campo_minado_app/core/models/match_data.dart';
import 'package:campo_minado_app/core/models/user_data.dart';
import 'package:campo_minado_app/core/services/match/match_firebase_service.dart';

abstract class MatchService {
  Stream<List<MatchData>> matchesStream();

  Future<void> addMatch(UserData user, bool won, int durationInSeconds);

  Future<void> removeMatch(String taskId);

  factory MatchService() => MatchFirebaseService();
}
