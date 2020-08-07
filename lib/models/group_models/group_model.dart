import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupModel extends ChangeNotifier {
  int currentIndex = 0;
  String groupName;

  Future init({String groupID}) async {
    DocumentSnapshot groupDoc =
        await Firestore.instance.collection('groups').document(groupID).get();
    groupName = groupDoc['groupName'];
    print(groupDoc);
    notifyListeners();
  }

  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
