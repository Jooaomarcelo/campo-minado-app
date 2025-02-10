import 'dart:io';

import 'package:campo_minado_app/components/result_widget.dart';
import 'package:campo_minado_app/core/services/auth_service.dart';
import 'package:flutter/material.dart';

class MinefieldPage extends StatefulWidget {
  const MinefieldPage({super.key});

  @override
  State<MinefieldPage> createState() => _MinefieldPageState();
}

class _MinefieldPageState extends State<MinefieldPage> {
  static const _defaultImage = 'assets/images/avatar.png';
  final _currentUser = AuthService().currentUser;

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
        ? debugPrint('Restart')
        : debugPrint('Don\'t Restart'));
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
          won: null,
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
                  value: 'logout',
                  child: Text('Sair'),
                )
              ],
              onSelected: (value) {
                if (value == 'logout') AuthService().logout();
              },
              child: _showUserImage(_currentUser?.imageUrl ?? _defaultImage),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Campo Minado'),
      ),
    );
  }
}
