import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserUpdatePasswordModel extends ChangeNotifier {
  String currentPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';
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

  Future updatePassword() async {
    final user = _auth.currentUser;
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
      throw ('新しいパスワードと新しいパスワード(確認用)が一致しません');
    }
    if (currentPassword == newPassword) {
      throw ('現在のパスワードとは異なるパスワードを作成してください');
    }
    try {
      await user.reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
        email: user.email,
        password: currentPassword,
      ));
      await user.updatePassword(newPassword);
    } catch (e) {
      print(e.code);
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'wrong-password':
      return '現在のパスワードが正しくありません';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'user-disabled':
      return 'ユーザーが無効です';
    case 'weak-password':
      return 'パスワードは6文字以上で作成してください';
    case 'too-many-requests':
      return 'しばらく待ってからお試し下さい';
    default:
      return 'エラーが発生しました';
  }
}
