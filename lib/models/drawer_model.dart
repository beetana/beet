import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userName = '';
  String email = '';
  List<String> groupName = [];
  List<String> groupID = [];

  Future getUserData() async {
    FirebaseUser currentUser = await auth.currentUser();
    var userData = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();

    userName = userData['name'];
    email = userData['email'];

    var joiningGroup = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('joiningGroup')
        .getDocuments();

    groupID = (joiningGroup.documents.map((doc) => doc.documentID).toList());

    for (String id in groupID) {
      DocumentSnapshot groupDoc =
          await Firestore.instance.collection('groups').document(id).get();
      groupName.add(groupDoc['groupName'].toString());
    }

    notifyListeners();
  }
}
