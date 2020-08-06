import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String groupName = '';
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addGroup() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    try {
      await Firestore.instance.collection('groups').add({
        'name': groupName,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
