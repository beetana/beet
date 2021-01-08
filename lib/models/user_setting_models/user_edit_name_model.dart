import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEditNameModel extends ChangeNotifier {
  String userID;
  String userName = '';
  bool isLoading = false;
  List<String> joiningGroupsID = [];

  void init({userID, userName}) {
    this.userID = userID;
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

  Future updateUserName() async {
    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }
    try {
      final joiningGroups = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      joiningGroupsID = (joiningGroups.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'name': userName,
      });
      for (String groupID in joiningGroupsID) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupID)
            .collection('groupUsers')
            .doc(userID)
            .update({
          'name': userName,
        });
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
