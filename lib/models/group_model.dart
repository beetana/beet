import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupModel extends ChangeNotifier {
  List<String> schedules = <String>['A', 'B', 'C'];

  Future getGroupData(String groupID) async {
    DocumentSnapshot groupDoc =
        await Firestore.instance.collection('groups').document(groupID).get();
    print(groupDoc);
    notifyListeners();
  }
}
