import 'package:campo_minado_app/core/models/user_data.dart';
import 'package:campo_minado_app/core/models/match_data.dart';
import 'package:campo_minado_app/core/services/auth/auth_service.dart';
import 'package:campo_minado_app/core/services/match/match_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MatchFirebaseService implements MatchService {
  @override
  Stream<List<MatchData>> matchesStream() {
    final store = FirebaseFirestore.instance;

    final snapshot = store
        .collection('matches')
        .where('userId', isEqualTo: AuthService().currentUser!.id)
        .orderBy('date', descending: true)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .snapshots();

    return snapshot.map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> addMatch(UserData user, bool won, int durationInSeconds) async {
    final store = FirebaseFirestore.instance;

    final match = MatchData(
      id: 'id',
      userId: user.id,
      won: won,
      durationInSeconds: durationInSeconds,
      date: DateTime.now(),
    );

    await store
        .collection('matches')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(match);
  }

  @override
  Future<void> removeMatch(String taskId) async {
    final store = FirebaseFirestore.instance;

    await store.collection('matches').doc(taskId).delete();
  }

  MatchData _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return MatchData(
      id: doc.id,
      userId: doc['userId'],
      won: doc['won'],
      durationInSeconds: doc['durationInSeconds'],
      date: DateTime.parse(doc['date']),
    );
  }

  Map<String, dynamic> _toFirestore(MatchData match, SetOptions? options) {
    return {
      'userId': match.userId,
      'won': match.won,
      'durationInSeconds': match.durationInSeconds,
      'date': match.date.toIso8601String(),
    };
  }
}
