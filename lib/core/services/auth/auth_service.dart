import 'dart:io';

import 'package:campo_minado_app/core/models/user_data.dart';
import 'package:campo_minado_app/core/services/auth/auth_firebase_service.dart';
import 'package:flutter/material.dart';

abstract class AuthService with ChangeNotifier {
  UserData? get currentUser;

  Stream<UserData?> get userChanges;

  Future<void> signup(String name, String email, String password, File? image);

  Future<void> login(String email, String password);

  Future<void> logout();

  factory AuthService() {
    return AuthFirebaseService();
  }
}
