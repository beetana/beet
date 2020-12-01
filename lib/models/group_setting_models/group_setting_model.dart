import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSettingModel extends ChangeNotifier {
  String groupName = '';
  String groupImageURL;

  Future init({groupID}) async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .get();
    groupName = groupDoc['name'];
    groupImageURL = groupDoc['imageURL'];
    notifyListeners();
  }
}
