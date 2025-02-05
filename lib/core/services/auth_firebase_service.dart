import 'dart:io';

import 'package:flutter/material.dart';

import 'package:campo_minado_app/core/models/user_data.dart';
import 'package:campo_minado_app/core/services/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService with ChangeNotifier implements AuthService {
  static UserData? _currentUser;

  @override
  UserData? get currentUser => _currentUser;

  Stream<UserData?> get userChanges =>
      FirebaseAuth.instance.authStateChanges().map(
        (user) {
          if (user == null) return null;

          return _toUserData(user);
        },
      );

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    // Criando credenciais
    UserCredential credentials = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credentials.user == null) return;

    // Upload da foto de usuário
    final imageName = '${credentials.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    // Atualizando atributos do usuário
    await credentials.user?.updateDisplayName(name);
    await credentials.user?.updatePhotoURL(imageUrl);

    await signup.delete();
  }

  @override
  Future<void> login(String email, String password) async {
    final auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);

    await imageRef.putFile(image).whenComplete(() {});

    return await imageRef.getDownloadURL();
  }

  static UserData _toUserData(User user, [String? imageUrl]) {
    return UserData(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }

  void _updateCurrentUser(UserData? user) {
    _currentUser = user;
    notifyListeners();
  }

  AuthFirebaseService() {
    userChanges.listen((user) {
      _updateCurrentUser(user);
    });
  }
}
