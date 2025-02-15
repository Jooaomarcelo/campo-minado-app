import 'dart:io';

import 'package:campo_minado_app/components/board_widget.dart';
import 'package:campo_minado_app/components/result_widget.dart';
import 'package:campo_minado_app/core/models/board.dart';
import 'package:campo_minado_app/core/models/explosion_exception.dart';
import 'package:campo_minado_app/core/models/field.dart';
import 'package:campo_minado_app/core/services/auth_service.dart';
import 'package:campo_minado_app/core/services/match/match_service.dart';
import 'package:flutter/material.dart';

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
          won: _won,
          onRestart: _restart,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              offset: Offset(0, 45),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'user',
                  child: Text('Meu perfil'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Sair'),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                } else {
                  Navigator.of(context).pushNamed(
                    '/user',
                    arguments: _currentUser,
                  );
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
            );
          },
        ),
      ),
    );
  }
}
