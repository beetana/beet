import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEditNameModel extends ChangeNotifier {
  String groupId;
  String groupName = '';
  bool isLoading = false;
  List<String> groupUsersId = [];

  void init({groupId, groupName}) {
    this.groupId = groupId;
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
          .doc(groupId)
          .collection('groupUsers')
          .get();
      groupUsersId = (groupUsers.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        'name': groupName,
      });
      for (String userId in groupUsersId) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('joiningGroup')
            .doc(groupId)
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
