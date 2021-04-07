import 'package:beet/utilities/convert_error_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserUpdateEmailModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;
  bool isAuthRequired = false;
  final _auth = Auth.FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({String email}) {
    this.email = email;
  }

  Future updateEmail() async {
    final user = _auth.currentUser;
    if (email.isEmpty || email == user.email) {
      throw ('新しいメールアドレスを入力してください');
    }
    try {
      if (isAuthRequired) {
        await user
            .reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
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
      throw (convertErrorMessage(e.code));
    }
  }
}
