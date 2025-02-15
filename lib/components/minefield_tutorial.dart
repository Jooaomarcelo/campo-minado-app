import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinefieldTutorial {
  late TutorialCoachMark _tutorialCoachMark;
  final List<TargetFocus> _targets = [];

  final GlobalKey fieldKey;
  final GlobalKey restartKey;
  final GlobalKey profileKey;

  MinefieldTutorial({
    required this.fieldKey,
    required this.restartKey,
    required this.profileKey,
  }) {
    _initTargets();
  }

  TargetFocus _getTargetWidget({
    required String identify,
    required GlobalKey key,
    required String title,
    required IconData icon,
    required void Function() onPressed,
    String? description,
    CrossAxisAlignment? crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      contents: [
        TargetContent(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment!,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              if (description != null)
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: onPressed,
                  child: Icon(icon),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _initTargets() {
    _targets.add(
      _getTargetWidget(
        identify: 'fieldExample',
        key: fieldKey,
        title: 'Campo Minado',
        description: 'Aperte para abrir um campo ou segure para marcá-lo',
        icon: Icons.navigate_next,
        onPressed: () => _tutorialCoachMark.next(),
      ),
    );
    _targets.add(
      _getTargetWidget(
        identify: 'restartExample',
        key: restartKey,
        title: 'Status da Partida',
        description: 'Aperte para reiniciar a partida',
        icon: Icons.navigate_next,
        onPressed: () => _tutorialCoachMark.next(),
      ),
    );
    _targets.add(
      _getTargetWidget(
        identify: 'profileExample',
        key: profileKey,
        title: 'Ver perfil',
        icon: Icons.done,
        onPressed: () => _tutorialCoachMark.finish(),
        crossAxisAlignment: CrossAxisAlignment.end,
      ),
    );
  }

  Future<void> showTutorialIfFirstTime(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      if (!context.mounted) return;

      _tutorialCoachMark = TutorialCoachMark(
        targets: _targets,
        colorShadow: Colors.black54,
        skipWidget: FloatingActionButton(
          onPressed: () {
            _tutorialCoachMark.finish();
          },
          child: const Text('Pular Tutorial', textAlign: TextAlign.center),
        ),
      )..show(context: context);

      await prefs.setBool('isFirstTime', false);
    }
  }

  void showTutorial(BuildContext context) {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _targets,
      colorShadow: Colors.black54,
      skipWidget: FloatingActionButton(
        onPressed: () {
          _tutorialCoachMark.finish();
        },
        child: const Text('Pular Tutorial', textAlign: TextAlign.center),
      ),
    )..show(context: context);
  }
}
