import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSettingModel extends ChangeNotifier {
  String groupName = '';

  Future init(groupID) async {
    final DocumentSnapshot groupDoc =
        await Firestore.instance.collection('groups').document(groupID).get();
    groupName = groupDoc['groupName'];
    notifyListeners();
  }
}
