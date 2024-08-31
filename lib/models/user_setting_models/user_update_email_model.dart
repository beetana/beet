import 'package:beet/utilities/convert_error_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserUpdateEmailModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;
  bool isAuthRequired = false;
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({required String email}) {
    this.email = email;
  }

  Future<void> updateEmail() async {
    final firebaseUser = _auth.currentUser!;

    if (email.isEmpty || email == firebaseUser.email) {
      throw ('新しいメールアドレスを入力してください');
    }

    try {
      if (isAuthRequired) {
        await firebaseUser
            .reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
          email: firebaseUser.email!,
          password: password,
        ));
      }
      await firebaseUser.updateEmail(email);
    } on Auth.FirebaseAuthException catch (e) {
      print(e.code);
      // 再認証が必要な場合はこのエラーコードが返ってくる
      if (e.code == 'requires-recent-login') {
        isAuthRequired = true;
      }
      throw (convertErrorMessage(e.code));
    }
  }
}
