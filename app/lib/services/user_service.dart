import 'package:app_flutter/models/usuario.dart';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<QuerySnapshot<Object?>> obterTodos() async {
    return users.get();
  }

  Future<Usuario> obterUsuarioPorId(String? id) async =>
      await users.doc(id).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data()! as Map<String, dynamic>;
          var usuario = Usuario().toEntity(data);
          return usuario;
        }
        return Usuario();
      });

  Future<String?> obterPhotoUsuarioPorId(String? id) async =>
      await users.doc(id).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data()! as Map<String, dynamic>;
          var usuario = Usuario().toEntity(data);
          return usuario.photo;
        }
        return "";
      });

  Future<QuerySnapshot<Object?>> obterUsuarioPorEmail(String email) async {
    return users.where('email', isEqualTo: email).get();
  }

  registrar(Usuario usuario) async {
    try {
      if (usuario.senha != usuario.confirmSenha) {
        throw CustomException('As senhas são diferentes!');
      }

      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      User? user = result.user;
      user?.updateDisplayName(usuario.name);
      user?.updatePhotoURL(usuario.photo);
      usuario.auth_id = user?.uid;

      if (auth.currentUser != null) {
        await users.doc(usuario.auth_id).set(usuario.toJson()).catchError(
            (error) => throw CustomException(
                "ocorreu um erro ao cadastrar tente novamente"));
      }
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('Este email já está cadastrado');
      } else if (e.code == 'unknown') {
        throw CustomException('Senha inválida');
      } else if (e.code == "invalid-email") {
        throw CustomException('Email inválido!');
      } else {
        throw CustomException('Erro ao cadastrar, tente novamente!');
      }
    }
  }

  atualizar(Usuario usuario) async {
    try {
      if (usuario.senha != usuario.confirmSenha) {
        throw CustomException('As senhas são diferentes!');
      }
      var user = auth.currentUser;
      user?.updateDisplayName(usuario.name);
      user?.updatePhotoURL(usuario.photo);
      usuario.id = user!.uid;
      if (auth.currentUser != null) {
        await users.doc(usuario.id).update(usuario.toJson()).catchError(
            (error) => throw CustomException(
                "ocorreu um erro ao cadastrar tente novamente"));
      }
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('Este email já está cadastrado');
      } else if (e.code == 'unknown') {
        throw CustomException('Senha inválida');
      } else if (e.code == "invalid-email") {
        throw CustomException('Email inválido!');
      } else {
        throw CustomException('Erro ao cadastrar, tente novamente!');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw CustomException('Senha incorreta. Tente novamente');
      }
    }
  }

  logout() async {
    await auth.signOut();
    _getUser();
  }
}
