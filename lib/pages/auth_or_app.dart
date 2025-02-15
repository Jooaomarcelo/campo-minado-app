import 'package:campo_minado_app/core/services/auth/auth_service.dart';
import 'package:campo_minado_app/pages/auth_page.dart';
import 'package:campo_minado_app/pages/minefield_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrApp extends StatelessWidget {
  const AuthOrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (ctx, authService, _) {
        if (authService.currentUser == null) {
          return const AuthPage();
        } else {
          return const MinefieldPage();
        }
      },
    );
  }
}
