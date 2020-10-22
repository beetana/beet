import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userID;
  String userName = '';
  List<String> groupName = [];
  List<String> groupID = [];

  Future getUserData() async {
    FirebaseUser currentUser = await auth.currentUser();
    userID = currentUser.uid;
    var userData =
        await Firestore.instance.collection('users').document(userID).get();

    var joiningGroup = await Firestore.instance
        .collection('users')
        .document(userID)
        .collection('joiningGroup')
        .getDocuments();

    userName = userData['name'];
    groupID = (joiningGroup.documents.map((doc) => doc.documentID).toList());

    for (String id in groupID) {
      DocumentSnapshot groupDoc =
          await Firestore.instance.collection('groups').document(id).get();
      groupName.add(groupDoc['groupName']);
    }
    notifyListeners();
  }
}
