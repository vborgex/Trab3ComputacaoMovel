// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para fazer login com email e senha
  Future<User?> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro desconhecido.';
      if (e.code == 'invalid-credential') {
        errorMessage = 'Usuário ou senha incorretos!';
      }
      _showErrorDialog(context, errorMessage);
      return null;
    }
  }

  // Função para registrar um usuário
  Future<User?> registerUser(String email, String password,
      String confirmPassword, BuildContext context) async {
    if (password != confirmPassword) {
      _showErrorDialog(context, "As senhas não conferem!");
      return null;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Erro desconhecido.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Este email já está sendo utilizado!';
      }
      _showErrorDialog(context, errorMessage);
      return null;
    }
  }

  // Função para mostrar uma mensagem de erro
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
