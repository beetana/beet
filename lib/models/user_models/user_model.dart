import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int currentIndex = 0;
  String userName;

  Future init() async {
    FirebaseUser currentUser = await auth.currentUser();
    final DocumentSnapshot userDoc = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
    userName = userDoc['name'];
    notifyListeners();
  }

  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
