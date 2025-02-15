import 'dart:io';

import 'package:campo_minado_app/components/minefield_tutorial.dart';
import 'package:flutter/material.dart';

import 'package:campo_minado_app/components/board_widget.dart';
import 'package:campo_minado_app/components/result_widget.dart';
import 'package:campo_minado_app/core/models/board.dart';
import 'package:campo_minado_app/core/models/explosion_exception.dart';
import 'package:campo_minado_app/core/models/field.dart';
import 'package:campo_minado_app/core/services/auth/auth_service.dart';
import 'package:campo_minado_app/core/services/match/match_service.dart';

class MinefieldPage extends StatefulWidget {
  const MinefieldPage({super.key});

  @override
  State<MinefieldPage> createState() => _MinefieldPageState();
}

class _MinefieldPageState extends State<MinefieldPage> {
  static const _defaultImage = 'assets/images/avatar.png';
  final _currentUser = AuthService().currentUser;

  bool? _won;
  Board? _board;

  DateTime? _start;
  int? _durationInSeconds;

  // Criando chaves globais para os campos do meio, do botão de reiniciar e do perfil
  // Essas chaves serão utilizadas para exibir o tutorial
  final GlobalKey _fieldKey = GlobalKey();
  final GlobalKey _restartKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();

  late MinefieldTutorial _minefieldTutorial;

  @override
  void initState() {
    super.initState();

    _minefieldTutorial = MinefieldTutorial(
      fieldKey: _fieldKey,
      restartKey: _restartKey,
      profileKey: _profileKey,
    );

    // Mostrar o tutorial após a renderização final da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _minefieldTutorial.showTutorialIfFirstTime(context);
    });
  }

  Board _getBoard(double width, double height) {
    if (_board == null) {
      final int columns = 15;
      final double fieldSize = width / columns;
      final int rows = (height / fieldSize).floor();

      _board = Board(
        rows: rows,
        columns: columns,
        minesCount: 10,
      );
    }

    return _board!;
  }

  void _open(Field field) {
    if (_won != null) return _restart();

    if (_board!.gameStarted == false) {
      _board!.start();

      _start = DateTime.now();
    }

    setState(() {
      try {
        field.open();

        if (_board!.finished) {
          _won = true;

          final end = DateTime.now();
          _durationInSeconds = end.difference(_start!).inSeconds;

          MatchService().addMatch(
            _currentUser!,
            _won!,
            _durationInSeconds!,
          );
        }
      } on ExplosionException {
        _won = false;

        final end = DateTime.now();
        _durationInSeconds = end.difference(_start!).inSeconds;

        MatchService().addMatch(
          _currentUser!,
          _won!,
          _durationInSeconds!,
        );

        _board!.revealMines();
      }
    });
  }

  void _toggleMark(Field field) {
    if (_won != null) return;
    setState(() {
      field.toggleMark();

      if (_board!.finished) {
        _won = true;

        final end = DateTime.now();
        _durationInSeconds = end.difference(_start!).inSeconds;

        MatchService().addMatch(
          _currentUser!,
          _won!,
          _durationInSeconds!,
        );
      }
    });
  }

  void _restart() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tem certeza?'),
        content: const Text('Quer reiniciar o jogo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sim'),
          ),
        ],
      ),
    ).then((isConfirmed) => isConfirmed == true
        ? setState(() {
            _won = null;
            _board!.restart();
          })
        : null);
  }

  Widget _showUserImage(String imageUrl) {
    ImageProvider? provider;
    final uri = Uri.parse(imageUrl);

    if (uri.path.contains(_defaultImage)) {
      provider = const AssetImage(_defaultImage);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ResultWidget(
          key: _restartKey,
          won: _won,
          onRestart: _restart,
        ),
        centerTitle: true,
        actions: [
          Container(
            key: _profileKey,
            margin: EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              offset: Offset(0, 45),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'user',
                  child: Text('Meu perfil'),
                ),
                PopupMenuItem(
                  value: 'tutorial',
                  child: Text('Ver Tutorial'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Sair'),
                ),
              ],
              onSelected: (value) {
                if (value == 'user') {
                  Navigator.of(context).pushNamed(
                    '/user',
                    arguments: _currentUser,
                  );
                } else if (value == 'tutorial') {
                  _minefieldTutorial.showTutorial(context);
                } else {
                  AuthService().logout();
                }
              },
              child: _showUserImage(_currentUser?.imageUrl ?? _defaultImage),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return BoardWidget(
              board: _getBoard(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
              onOpen: _open,
              onToggleMark: _toggleMark,
              tutorialFieldKey: _fieldKey,
            );
          },
        ),
      ),
    );
  }
}
