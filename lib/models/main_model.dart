import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userID;

  Future getUserID() async {
    FirebaseUser currentUser = await auth.currentUser();
    userID = currentUser.uid;
    notifyListeners();
  }
}
