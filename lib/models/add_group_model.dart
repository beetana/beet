import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String userName = '';
  String userImageURL = '';
  String groupName = '';
  String groupId;
  bool isLoading = false;
  final _auth = Auth.FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({String userName, String userImageURL}) {
    this.userName = userName;
    this.userImageURL = userImageURL;
  }

  Future addGroup() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    Auth.User user = _auth.currentUser;
    try {
      final newGroup =
          await FirebaseFirestore.instance.collection('groups').add({
        'name': groupName,
        'imageURL': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      groupId = newGroup.id;
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .doc(user.uid)
          .set({
        'name': userName,
        'imageURL': userImageURL,
        'joinedAt': FieldValue.serverTimestamp(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('joiningGroup')
          .doc(groupId)
          .set({
        'name': groupName,
        'imageURL': '',
        'joinedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
