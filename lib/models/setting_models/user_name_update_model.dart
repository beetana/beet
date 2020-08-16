import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserNameUpdateModel extends ChangeNotifier {
  String userName;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateUserName() async {
    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }
    try {
      final user = await _auth.currentUser();
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({
        'name': userName,
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
