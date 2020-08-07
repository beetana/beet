import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String groupName = '';
  String groupID = '';
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      final newGroup = await Firestore.instance.collection('groups').add({
        'groupName': groupName,
        'createdAt': Timestamp.now(),
      });
      final FirebaseUser user = await _auth.currentUser();
      groupID = newGroup.documentID;
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('joiningGroup')
          .document(groupID)
          .setData({'joinedAt': Timestamp.now()});
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
