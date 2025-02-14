import 'package:flutter/material.dart';

import 'package:campo_minado_app/components/user_recent_match.dart';
import 'package:campo_minado_app/components/user_sliver_header.dart';
import 'package:campo_minado_app/components/user_status_bar.dart';
import 'package:campo_minado_app/components/user_performance_overview.dart';

import 'package:campo_minado_app/core/models/match_data.dart';
import 'package:campo_minado_app/core/models/user_data.dart';
import 'package:campo_minado_app/core/services/match/match_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as UserData;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: UserSliverHeader(user),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                StreamBuilder(
                  stream: MatchService().matchesStream(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('Nenhuma partida jogada!');
                    } else {
                      final matches = snapshot.data as List<MatchData>;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            UserStatusBar(matches),
                            SizedBox(height: 20),
                            UserRecentMatch(matches.take(5).toList()),
                            SizedBox(height: 20),
                            UserPerformanceOverview(matches),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
