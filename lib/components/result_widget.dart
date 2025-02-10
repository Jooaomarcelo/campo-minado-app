import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final bool? won;
  final void Function() onRestart;

  const ResultWidget({
    required this.won,
    required this.onRestart,
    super.key,
  });

  Color _getColor() {
    if (won == null) {
      return Colors.yellow;
    } else if (won!) {
      return Colors.green[300]!;
    } else {
      return Colors.red[300]!;
    }
  }

  IconData _getIcon() {
    if (won == null) {
      return Icons.sentiment_satisfied;
    } else if (won!) {
      return Icons.sentiment_very_satisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: _getColor(),
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          _getIcon(),
          color: Colors.black,
          size: 35,
        ),
        onPressed: onRestart,
      ),
    );
  }
}
