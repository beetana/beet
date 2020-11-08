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
    User user = auth.currentUser;
    userID = user.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    QuerySnapshot joiningGroup = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('joiningGroup')
        .get();

    userImageURL = userDoc['imageURL'];
    userName = userDoc['name'];
    groupID = (joiningGroup.docs.map((doc) => doc.id).toList());

    for (String id in groupID) {
      DocumentSnapshot groupDoc =
          await FirebaseFirestore.instance.collection('groups').doc(id).get();
      groupName.add(groupDoc['groupName']);
    }
    notifyListeners();
  }
}
