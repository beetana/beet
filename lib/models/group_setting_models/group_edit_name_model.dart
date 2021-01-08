import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEditNameModel extends ChangeNotifier {
  String groupID;
  String groupName = '';
  bool isLoading = false;
  List<String> groupUsersID = [];

  void init({groupID, groupName}) {
    this.groupID = groupID;
    this.groupName = groupName;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateGroupName() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    try {
      final groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .get();
      groupUsersID = (groupUsers.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .update({
        'name': groupName,
      });
      for (String userID in groupUsersID) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('joiningGroup')
            .doc(groupID)
            .update({
          'name': groupName,
        });
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
