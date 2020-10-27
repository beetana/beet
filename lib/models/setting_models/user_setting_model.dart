import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingModel extends ChangeNotifier {
  String userName = '';
  String userImageURL;

  Future init({userID}) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(userID).get();
    userName = user['name'];
    userImageURL = user['imageURL'];
    notifyListeners();
  }
}
