import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeModel extends ChangeNotifier {
  String email = '';
  String password = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (email.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      await Firestore.instance.collection('users').document(user.uid).setData({
        'email': user.email,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw (_convertErrorMessage(e.code));
    }
  }

  Future login() async {
    if (email.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'ERROR_INVALID_EMAIL':
      return 'メールアドレスを正しい形式で入力してください';
    case 'ERROR_WRONG_PASSWORD':
      return 'パスワードが間違っています';
    case 'ERROR_USER_NOT_FOUND':
      return 'ユーザーが見つかりません';
    case 'ERROR_USER_DISABLED':
      return 'ユーザーが無効です';
    case 'ERROR_TOO_MANY_REQUESTS':
      return 'ログインに失敗しました。しばらく経ってから再度お試しください';
    case 'ERROR_OPERATION_NOT_ALLOWED':
      return 'ログインが許可されていません。管理者にご連絡ください';
    default:
      return '不明なエラーです';
  }
}
