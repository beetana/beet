import 'package:beet/utilities/convert_error_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordModel extends ChangeNotifier {
  String email = '';
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      print(e.code);
      throw (convertErrorMessage(e.code));
    }
  }
}
