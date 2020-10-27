import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userID;
  String userImageURL;
  String userName = '';
  List<String> groupName = [];
  List<String> groupID = [];

  Future init() async {
    FirebaseUser user = await auth.currentUser();
    userID = user.uid;
    DocumentSnapshot userDoc =
        await Firestore.instance.collection('users').document(userID).get();

    QuerySnapshot joiningGroup = await Firestore.instance
        .collection('users')
        .document(userID)
        .collection('joiningGroup')
        .getDocuments();

    userImageURL = userDoc['imageURL'];
    userName = userDoc['name'];
    groupID = (joiningGroup.documents.map((doc) => doc.documentID).toList());

    for (String id in groupID) {
      DocumentSnapshot groupDoc =
          await Firestore.instance.collection('groups').document(id).get();
      groupName.add(groupDoc['groupName']);
    }
    notifyListeners();
  }
}
