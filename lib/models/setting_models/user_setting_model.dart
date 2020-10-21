import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingModel extends ChangeNotifier {
  String userID;
  String userName = '';

  Future init({userID}) async {
    this.userID = userID;
    final DocumentSnapshot user =
        await Firestore.instance.collection('users').document(userID).get();
    userName = user['name'];
    notifyListeners();
  }
}
