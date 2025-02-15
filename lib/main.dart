import 'package:campo_minado_app/pages/user_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:campo_minado_app/core/services/auth/auth_firebase_service.dart';
import 'package:campo_minado_app/core/services/auth/auth_service.dart';
import 'package:campo_minado_app/pages/auth_or_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (ctx) => AuthFirebaseService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue[900]!,
            brightness: Brightness.dark,
            secondary: Colors.yellow[300],
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (ctx) => const AuthOrApp(),
          '/user': (ctx) => const UserPage(),
        },
      ),
    );
  }
}
