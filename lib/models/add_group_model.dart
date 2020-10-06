import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String userName = '';
  String groupName = '';
  String groupID;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void init(userName) {
    this.userName = userName;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addGroup() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    FirebaseUser user = await _auth.currentUser();
    try {
      final newGroup = await Firestore.instance.collection('groups').add({
        'groupName': groupName,
        'createdAt': Timestamp.now(),
        'userCount': 1,
      });
      groupID = newGroup.documentID;
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .collection('groupUsers')
          .document(user.uid)
          .setData({
        'userID': user.uid,
        'userName': userName,
        'joinedAt': Timestamp.now(),
      });
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('joiningGroup')
          .document(groupID)
          .setData({
        'groupName': groupName,
        'joinedAt': Timestamp.now(),
      });
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({
        'groupCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
