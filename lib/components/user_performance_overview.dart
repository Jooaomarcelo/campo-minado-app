import 'package:campo_minado_app/core/models/match_data.dart';
import 'package:flutter/material.dart';

class UserPerformanceOverview extends StatelessWidget {
  final List<MatchData> matches;

  const UserPerformanceOverview(this.matches, {super.key});

  Widget _getContainer(IconData icon, String value, String text) {
    return Container(
      height: 175,
      width: 125,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 35),
          Divider(
            color: Colors.white,
          ),
          Expanded(child: Center(child: Text(value))),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wonMatches = matches.where((match) => match.won).length;
    final lostMatches = matches.length - wonMatches;

    final averageGameDuration = matches.fold<int>(0,
            (currentValue, match) => currentValue + match.durationInSeconds) /
        matches.length;
    final averageGameDurationString =
        '${(averageGameDuration / 60).floor()}:${(averageGameDuration % 60).floor().toString().padLeft(2, '0')}';

    return Column(
      children: [
        Text(
          'Desempenho',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: wonMatches / matches.length,
                  strokeWidth: 30,
                  color: Colors.green,
                  backgroundColor: Colors.red,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Vitória: ${wonMatches.toString()}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      'Derrota: ${lostMatches.toString()}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _getContainer(Icons.timer_outlined, averageGameDurationString,
                'Tempo médio p/ jogo'),
            _getContainer(
                Icons.bar_chart_rounded,
                (wonMatches / matches.length).toStringAsFixed(2),
                'Vitória / Derrota'),
          ],
        )
      ],
    );
  }
}
