import 'package:campo_minado_app/core/models/match_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserRecentMatch extends StatelessWidget {
  final List<MatchData> recentMatches;

  const UserRecentMatch(this.recentMatches, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recentMatches.map((match) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          elevation: 3,
          shadowColor: Colors.grey[600],
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                match.won ? Icons.check : Icons.whatshot,
                color: match.won ? Colors.green : Colors.red,
              ),
            ),
            title: Text(match.won ? 'Vitória' : 'Explodiu'),
            subtitle: Text(DateFormat('dd/MM/yyyy - HH:mm').format(match.date)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(match.durationInSeconds / 60).floor()}:${(match.durationInSeconds % 60).toString().padLeft(2, '0')}',
                ),
                Icon(Icons.timer_sharp),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
