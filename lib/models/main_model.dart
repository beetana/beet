import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userID;
  List<String> schedules = <String>['A', 'B', 'C'];

  Future getUserID() async {
    FirebaseUser currentUser = await auth.currentUser();
    userID = currentUser.uid;
    notifyListeners();
  }
}
