import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserEditNameModel extends ChangeNotifier {
  String userName = '';
  bool isLoading = false;
  List<String> joiningGroupsId = [];
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

  void init({String userName}) {
    this.userName = userName;
  }

  Future updateUserName() async {
    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }
    final Auth.User firebaseUser = auth.currentUser;
    final String userId = firebaseUser.uid;
    final batch = firestore.batch();
    final userDocRef = firestore.collection('users').doc(userId);
    batch.update(userDocRef, {
      'name': userName,
    });
    try {
      final joiningGroupsQuery = await firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroup')
          .get();
      joiningGroupsId = (joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      for (String groupId in joiningGroupsId) {
        final groupUserDocRef = firestore
            .collection('groups')
            .doc(groupId)
            .collection('groupUsers')
            .doc(userId);
        batch.update(groupUserDocRef, {
          'name': userName,
        });
      }
      await batch.commit();
      await firebaseUser.updateProfile(displayName: userName);
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
