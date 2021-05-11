import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserEditNameModel extends ChangeNotifier {
  String userName = '';
  bool isLoading = false;
  List<String> joiningGroupsId = [];
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> updateUserName() async {
    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }

    final Auth.User firebaseUser = _auth.currentUser;
    final String userId = firebaseUser.uid;
    final WriteBatch batch = _firestore.batch();
    final DocumentReference userDocRef = _firestore.collection('users').doc(userId);

    batch.update(userDocRef, {
      'name': userName,
    });

    try {
      final QuerySnapshot joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();
      joiningGroupsId = (joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      for (String groupId in joiningGroupsId) {
        final DocumentReference memberDocRef = _firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc(userId);
        batch.update(memberDocRef, {
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
