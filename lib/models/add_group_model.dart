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
    User user = _auth.currentUser;
    try {
      final newGroup =
          await FirebaseFirestore.instance.collection('groups').add({
        'name': groupName,
        'createdAt': Timestamp.now(),
        'userCount': 1,
      });
      groupID = newGroup.id;
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .doc(user.uid)
          .set({
        'userID': user.uid,
        'userName': userName,
        'joinedAt': Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('joiningGroup')
          .doc(groupID)
          .set({
        'name': groupName,
        'joinedAt': Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'groupCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
