import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupNameUpdateModel extends ChangeNotifier {
  String groupID;
  String groupName = '';
  bool isLoading = false;

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
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .updateData({
        'groupName': groupName,
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
