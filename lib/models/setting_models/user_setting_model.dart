import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettingModel extends ChangeNotifier {
  String userName = '';

  Future init() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    final DocumentSnapshot user = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get();
    userName = user['name'];
    notifyListeners();
  }
}
