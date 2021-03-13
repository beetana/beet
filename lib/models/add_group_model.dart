import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupModel extends ChangeNotifier {
  String userId = '';
  String userName = '';
  String userImageURL = '';
  String groupName = '';
  String groupId = '';
  bool isLoading = false;
  DocumentReference userDocRef;
  final auth = Auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init() {
    this.userId = auth.currentUser.uid;
    this.userDocRef = firestore.collection('users').doc(userId);
  }

  Future addGroup() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    try {
      final joiningGroup = await userDocRef.collection('joiningGroup').get();

      if (joiningGroup.size < 8) {
        final userDoc = await userDocRef.get();
        this.userName = userDoc['name'];
        this.userImageURL = userDoc['imageURL'];
        final newGroup = await firestore.collection('groups').add({
          'name': groupName,
          'imageURL': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        this.groupId = newGroup.id;
        await firestore
            .collection('groups')
            .doc(groupId)
            .collection('groupUsers')
            .doc(userId)
            .set({
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });
        await userDocRef.collection('joiningGroup').doc(groupId).set({
          'name': groupName,
          'imageURL': '',
          'joinedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw ('エラーが発生しました');
    }
  }
}
