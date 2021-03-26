import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserEditNameModel extends ChangeNotifier {
  String userId;
  String userName = '';
  bool isLoading = false;
  List<String> joiningGroupsId = [];
  final _auth = Auth.FirebaseAuth.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({String userId, String userName}) {
    this.userId = userId;
    this.userName = userName;
  }

  Future updateUserName() async {
    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }
    try {
      final joiningGroups = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('joiningGroup')
          .get();
      joiningGroupsId = (joiningGroups.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': userName,
      });
      for (String groupId in joiningGroupsId) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('groupUsers')
            .doc(userId)
            .update({
          'name': userName,
        });
      }
      await _auth.currentUser.updateProfile(displayName: userName);
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
