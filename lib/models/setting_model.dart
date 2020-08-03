import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beet/user.dart';

class SettingModel extends ChangeNotifier {
  String userName;

  Future init() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    final DocumentSnapshot userDoc = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get();
    final user = User(userDoc);
    this.userName = user.name;
    notifyListeners();
  }
}
