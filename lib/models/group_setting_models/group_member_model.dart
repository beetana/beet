import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupId = '';
  String groupName = '';
  String groupImageURL = '';
  String myId = '';
  List<String> usersId = [];
  List<String> usersName = [];
  List<String> usersImageURL = [];
  bool isLoading = false;
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String groupId}) async {
    startLoading();
    this.groupId = groupId;
    this.myId = Auth.FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentSnapshot groupDoc =
          await firestore.collection('groups').doc(groupId).get();
      this.groupName = groupDoc['name'];
      this.groupImageURL = groupDoc['imageURL'];
      await fetchGroupUsers();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchGroupUsers() async {
    try {
      QuerySnapshot groupUsers = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .get();
      this.usersId = (groupUsers.docs.map((doc) => doc.id).toList());
      this.usersName =
          (groupUsers.docs.map((doc) => doc['name'].toString()).toList());
      this.usersImageURL =
          (groupUsers.docs.map((doc) => doc['imageURL'].toString()).toList());
    } catch (e) {
      print(e);
    }
  }

  Future<int> checkMemberCount() async {
    int memberCount;
    try {
      final groupUsersQuery = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .get();
      memberCount = groupUsersQuery.size;
    } catch (e) {
      print(e);
    }
    return memberCount;
  }

  Future deleteMember({String userId}) async {
    final batch = firestore.batch();
    final joiningGroupDocRef = firestore
        .collection('users')
        .doc(userId)
        .collection('joiningGroup')
        .doc(groupId);
    final groupUserDocRef = firestore
        .collection('groups')
        .doc(groupId)
        .collection('groupUsers')
        .doc(userId);
    batch.delete(joiningGroupDocRef);
    batch.delete(groupUserDocRef);
    try {
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteGroup({String userId}) async {
    final groupDocRef = firestore.collection('groups').doc(groupId);
    final joiningGroupDocRef = firestore
        .collection('users')
        .doc(userId)
        .collection('joiningGroup')
        .doc(groupId);
    final batch = firestore.batch();
    try {
      // Firebase Storage内のグループのプロフィール画像を削除
      if (groupImageURL.isNotEmpty) {
        await FirebaseStorage.instance
            .ref()
            .child("groupImage/$groupId")
            .delete();
      }
      // ユーザーのjoiningGroupからこのグループを削除
      batch.delete(joiningGroupDocRef);
      // グループのドキュメントを削除するとCloud FunctionsのdeleteGroupがトリガーされ、
      // そのグループのサブコレクションも削除される
      batch.delete(groupDocRef);
      await batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
