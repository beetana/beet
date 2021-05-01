import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String userName = '';
  String userImageURL = '';
  String groupName = '';
  String groupId = '';
  bool isLoading = false;
  final String userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addGroup() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    final DocumentReference userDocRef =
        _firestore.collection('users').doc(userId);
    final WriteBatch batch = _firestore.batch();
    try {
      final QuerySnapshot joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();

      if (joiningGroupsQuery.size < 8) {
        final DocumentSnapshot userDoc = await userDocRef.get();
        userName = userDoc['name'];
        userImageURL = userDoc['imageURL'];
        final DocumentReference newGroup =
            await _firestore.collection('groups').add({
          'name': groupName,
          'imageURL': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        groupId = newGroup.id;
        final DocumentReference memberDocRef = _firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc(userId);
        batch.set(memberDocRef, {
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });
        final DocumentReference joiningGroupDocRef =
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
