import 'package:beet/objects/joining_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  String userImageURL = '';
  String userName = '';
  List<JoiningGroup> joiningGroups = [];
  bool isLoading = false;
  final String userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init() async {
    startLoading();
    try {
      final DocumentReference userDocRef =
          _firestore.collection('users').doc(userId);
      final DocumentSnapshot userDoc = await userDocRef.get();
      final QuerySnapshot joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();

      userImageURL = userDoc['imageURL'];
      userName = userDoc['name'];
      joiningGroups =
          joiningGroupsQuery.docs.map((doc) => JoiningGroup.doc(doc)).toList();
      joiningGroups.sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
    } catch (e) {
      print(e);
    }
    endLoading();
  }
}
