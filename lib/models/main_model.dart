import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userName;
  List<String> schedules = <String>['A', 'B', 'C'];

  Future init() async {
    FirebaseUser currentUser = await auth.currentUser();
    final DocumentSnapshot userDoc = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
    userName = userDoc['name'];
    notifyListeners();
  }
}
