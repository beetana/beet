import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupModel extends ChangeNotifier {
  String groupName = '';
  int currentIndex = 0;

  Future init({String groupID}) async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .get();
    groupName = groupDoc['groupName'];
    notifyListeners();
  }

  void onTabTapped(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }
}
