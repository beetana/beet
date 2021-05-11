import 'package:beet/utilities/convert_error_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserUpdatePasswordModel extends ChangeNotifier {
  String currentPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';
  bool isLoading = false;
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePassword() async {
    final Auth.User firebaseUser = _auth.currentUser;
    if (currentPassword.isEmpty) {
      throw ('現在のパスワードを入力してください');
    }
    if (newPassword.isEmpty) {
      throw ('新しいパスワードを入力してください');
    }
    if (confirmNewPassword.isEmpty) {
      throw ('新しいパスワード(確認用)を入力してください');
    }
    if (newPassword != confirmNewPassword) {
      throw ('新しいパスワード(確認用)が一致しません');
    }
    if (currentPassword == newPassword) {
      throw ('現在のパスワードとは異なるパスワードを作成してください');
    }

    try {
      await firebaseUser
          .reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
        email: firebaseUser.email,
        password: currentPassword,
      ));
      await firebaseUser.updatePassword(newPassword);
    } catch (e) {
      print(e.code);
      throw (convertErrorMessage(e.code));
    }
  }
}
