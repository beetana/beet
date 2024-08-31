import 'package:beet/utilities/convert_error_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isAgree = false;
  bool isLoading = false;
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> register() async {
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
      final user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      // ユーザーが登録後に確認メールを送信
      await user.sendEmailVerification();
      await user.updateProfile(displayName: name);
      final String userId = user.uid;
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'imageURL': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on Auth.FirebaseAuthException catch (e) {
      print(e.code);
      throw (convertErrorMessage(e.code));
    }
  }
}
