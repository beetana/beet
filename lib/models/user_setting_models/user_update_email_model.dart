import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserUpdateEmailModel extends ChangeNotifier {
  String userID;
  String email = '';
  String password = '';
  bool isLoading = false;
  bool isAuthRequired = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void init({userID, email}) {
    this.userID = userID;
    this.email = email;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateEmail() async {
    final user = _auth.currentUser;
    if (email.isEmpty || email == user.email) {
      throw ('新しいメールアドレスを入力してください');
    }
    try {
      if (isAuthRequired) {
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(
          email: user.email,
          password: password,
        ));
      }
      await user.updateEmail(email);
    } catch (e) {
      print(e.code);
      if (e.code == 'requires-recent-login') {
        isAuthRequired = true;
      }
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'requires-recent-login':
      return 'パスワードの入力が必要です';
    case 'wrong-password':
      return 'パスワードが正しくありません';
    case 'email-already-in-use':
      return 'そのメールアドレスはすでに使用されています';
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください';
    case 'too-many-requests':
      return 'しばらく待ってからお試し下さい';
    default:
      return 'エラーが発生しました';
  }
}
