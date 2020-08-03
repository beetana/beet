import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = '';
  String email = '';

  void getUserData() async {
    FirebaseUser currentUser = await auth.currentUser();
    var userData = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
    name = userData['name'];
    email = userData['email'];
    notifyListeners();
  }
}
