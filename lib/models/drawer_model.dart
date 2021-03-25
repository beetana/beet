import 'package:beet/objects/joining_group.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  final auth = Auth.FirebaseAuth.instance;
  String userId;
  String userImageURL = '';
  String userName = '';
  List<JoiningGroup> joiningGroups = [];
  bool isLoading = false;
  final firestore = FirebaseFirestore.instance;

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
    userId = auth.currentUser.uid;
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      QuerySnapshot joiningGroupQuery = await firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroup')
          .get();

      userImageURL = userDoc['imageURL'];
      userName = userDoc['name'];
      joiningGroups =
          joiningGroupQuery.docs.map((doc) => JoiningGroup.doc(doc)).toList();
      joiningGroups.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    } catch (e) {
      print(e);
    } finally {
      endLoading();
    }
  }
}
