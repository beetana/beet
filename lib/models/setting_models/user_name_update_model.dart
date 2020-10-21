import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserNameUpdateModel extends ChangeNotifier {
  String userID;
  String userName = '';
  bool isLoading = false;

  void init({userID, userName}) {
    this.userID = userID;
    this.userName = userName;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateUserName() async {
    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }
    try {
      await Firestore.instance.collection('users').document(userID).updateData({
        'name': userName,
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
