import 'dart:io';

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
        title: const Text('Campo Minado'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: PopupMenuButton(
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
          )
        ],
      ),
      body: Center(
        child: Text('Campo Minado'),
      ),
    );
  }
}
