import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEditNameModel extends ChangeNotifier {
  String groupId = '';
  String groupName = '';
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void init({String groupId, String groupName}) {
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

  Future<void> updateGroupName() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }

    final WriteBatch batch = _firestore.batch();
    final DocumentReference groupDocRef =
        _firestore.collection('groups').doc(groupId);
    batch.update(groupDocRef, {
      'name': groupName,
    });

    try {
      final QuerySnapshot membersQuery =
          await groupDocRef.collection('members').get();
      final List<String> membersId =
          (membersQuery.docs.map((doc) => doc.id).toList());
      for (String userId in membersId) {
        final DocumentReference joiningGroupDocRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('joiningGroups')
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
