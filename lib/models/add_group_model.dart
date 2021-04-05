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
      final joiningGroupQuery =
          await userDocRef.collection('joiningGroup').get();

      if (joiningGroupQuery.size < 8) {
        final userDoc = await userDocRef.get();
        userName = userDoc['name'];
        userImageURL = userDoc['imageURL'];
        final newGroup = await firestore.collection('groups').add({
          'name': groupName,
          'imageURL': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        groupId = newGroup.id;
        final groupUserDocRef = firestore
            .collection('groups')
            .doc(groupId)
            .collection('groupUsers')
            .doc(userId);
        batch.set(groupUserDocRef, {
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });
        final joiningGroupDocRef =
            userDocRef.collection('joiningGroup').doc(groupId);
        batch.set(joiningGroupDocRef, {
          'name': groupName,
          'imageURL': '',
          'joinedAt': FieldValue.serverTimestamp(),
        });
        await batch.commit();
      }
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
