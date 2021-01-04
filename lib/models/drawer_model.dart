import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  final _auth = Auth.FirebaseAuth.instance;
  String userID;
  String userImageURL = '';
  String userName = '';
  List<String> groupName = [];
  List<String> groupID = [];
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init() async {
    startLoading();
    userID = _auth.currentUser.uid;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      QuerySnapshot joiningGroup = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();

      userImageURL = userDoc['imageURL'];
      userName = userDoc['name'];
      groupID = (joiningGroup.docs.map((doc) => doc.id).toList());
      groupName =
          (joiningGroup.docs.map((doc) => doc['name'].toString()).toList());
    } catch (e) {
      print(e);
    } finally {
      endLoading();
    }
  }
}
