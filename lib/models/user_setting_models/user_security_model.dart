import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class UserSecurityModel extends ChangeNotifier {
  String userId;
  String email;
  bool isLoading = false;

  void init({String userId}) {
    this.userId = userId;
    final firebaseUser = Auth.FirebaseAuth.instance.currentUser;
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
      await Auth.FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
