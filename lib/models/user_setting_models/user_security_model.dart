import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class UserSecurityModel extends ChangeNotifier {
  String email = '';
  bool isLoading = false;
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;

  void init() {
    final firebaseUser = _auth.currentUser!;
    email = firebaseUser.email!;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
