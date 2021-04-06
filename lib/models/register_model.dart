import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterModel extends ChangeNotifier {
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isAgree = false;
  bool isLoading = false;
  final _auth = Auth.FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void toggleCheckState() {
    isAgree = !isAgree;
    notifyListeners();
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
    if (confirmPassword.isEmpty) {
      throw ('パスワード(確認用)を入力してください');
    }
    if (password != confirmPassword) {
      throw ('パスワード(確認用)が一致しません');
    }

    try {
      final Auth.User user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      await user.updateProfile(displayName: name);
      final userId = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'imageURL': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.code);
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください。';
    case 'email-already-in-use':
      return 'そのメールアドレスはすでに使用されています。';
    case 'weak-password':
      return 'パスワードは6文字以上で作成してください。';
    case 'too-many-requests':
      return 'しばらく待ってからお試し下さい。';
    default:
      return 'エラーが発生しました。';
  }
}
