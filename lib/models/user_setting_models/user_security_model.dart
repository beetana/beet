import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class UserSecurityModel extends ChangeNotifier {
  String email;
  bool isLoading = false;
  final _auth = Auth.FirebaseAuth.instance;

  void init() {
    final firebaseUser = _auth.currentUser;
    this.email = firebaseUser.email;
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

  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
