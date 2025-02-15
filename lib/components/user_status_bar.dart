import 'package:campo_minado_app/core/models/match_data.dart';
import 'package:flutter/material.dart';

class UserStatusBar extends StatelessWidget {
  final List<MatchData> matches;

  const UserStatusBar(this.matches, {super.key});

  Widget _getItem(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 35),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _getSeparator() {
    return Container(
      height: 35,
      width: 1.5,
      color: Colors.black87,
    );
  }

  int _getWinningStreak(List<MatchData> matches) {
    int streak = 0;

    for (final match in matches) {
      if (match.won) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getItem(Icons.check, Colors.green,
                '${matches.where((m) => m.won).length}'),
            _getSeparator(),
            _getItem(
                Icons.whatshot, Colors.red, '${_getWinningStreak(matches)}'),
            _getSeparator(),
            _getItem(Icons.flag, Colors.blue, '${matches.length}'),
          ],
        ),
      ),
    );
  }
}
