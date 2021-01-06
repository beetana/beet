import 'package:beet/dynamic_links_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeModel extends ChangeNotifier {
  String userID;
  String name = '';
  String email = '';
  String password = '';
  final _auth = Auth.FirebaseAuth.instance;
  final dynamicLinks = DynamicLinksServices();

  void init(context) {
    dynamicLinks.promptLogin(context);
  }

  Future register() async {
    if (name.isEmpty) {
      throw ('アカウント名を入力してください');
    }
    if (email.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    try {
      final Auth.User user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      userID = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(userID).set({
        'name': name,
        'imageURL': '',
        'groupCount': 0,
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
      Auth.User user = _auth.currentUser;
      userID = user.uid;
    } catch (e) {
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください';
    case 'email-already-in-use':
      return 'そのメールアドレスはすでに使用されています';
    case 'wrong-password':
      return 'パスワードが間違っています';
    case 'weak-password':
      return 'パスワードは6文字以上で作成してください';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'user-disabled':
      return 'ユーザーが無効です';
    case 'too-many-requests':
      return 'しばらく待ってからお試し下さい';
    default:
      return '不明なエラーです';
  }
}
