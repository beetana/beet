import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String userName = '';
  String userImageURL = '';
  String groupName = '';
  String groupId = '';
  bool isLoading = false;
  final firestore = FirebaseFirestore.instance;
  final String userId = Auth.FirebaseAuth.instance.currentUser.uid;

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
    final userDocRef = firestore.collection('users').doc(userId);
    final batch = firestore.batch();
    try {
      final joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();

      if (joiningGroupsQuery.size < 8) {
        final userDoc = await userDocRef.get();
        userName = userDoc['name'];
        userImageURL = userDoc['imageURL'];
        final newGroup = await firestore.collection('groups').add({
          'name': groupName,
          'imageURL': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        groupId = newGroup.id;
        final memberDocRef = firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc(userId);
        batch.set(memberDocRef, {
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });
        final joiningGroupDocRef =
            userDocRef.collection('joiningGroups').doc(groupId);
        batch.set(joiningGroupDocRef, {
          'name': groupName,
          'imageURL': '',
          'joinedAt': FieldValue.serverTimestamp(),
        });
        await batch.commit();
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
