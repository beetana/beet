import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEditNameModel extends ChangeNotifier {
  String groupId;
  String groupName = '';
  bool isLoading = false;
  List<String> groupUsersId = [];
  final firestore = FirebaseFirestore.instance;

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
    final batch = firestore.batch();
    final groupDocRef = firestore.collection('groups').doc(groupId);
    batch.update(groupDocRef, {
      'name': groupName,
    });
    try {
      final groupUsersQuery = await groupDocRef.collection('groupUsers').get();
      groupUsersId = (groupUsersQuery.docs.map((doc) => doc.id).toList());
      for (String userId in groupUsersId) {
        final joiningGroupDocRef = firestore
            .collection('users')
            .doc(userId)
            .collection('joiningGroup')
            .doc(groupId);
        batch.update(joiningGroupDocRef, {
          'name': groupName,
        });
      }
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
