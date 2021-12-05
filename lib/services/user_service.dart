import 'package:app_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class UserService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User? usuario;
  bool isLoading = true;

  UserService() {
    _authChek();
  }

  _authChek() {
    auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = auth.currentUser;
    notifyListeners();
  }

  registrar(Usuario usuario) async {
    try {
      if (usuario.senha != usuario.confirmSenha) {
        throw AuthException('As senhas são diferentes!');
      }

      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      User? user = result.user;
      user?.updateDisplayName(usuario.name);
      usuario.auth_id = user?.uid;

      if (auth.currentUser != null) {
        await users.add(usuario.toJson()).catchError((error) =>
            throw AuthException(
                "ocorreu um erro ao cadastrar tente novamente"));
      }
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      } else if (e.code == 'unknown') {
        throw AuthException('Senha inválida');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
  }

  logout() async {
    await auth.signOut();
    _getUser();
  }
}
