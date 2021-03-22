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
      print(groupName);
      print(groupUsers.size);
      print(usersId);
      print(usersName);
      print(myId);
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
    final userDocRef = firestore.collection('users').doc(userId);
    final groupDocRef = firestore.collection('groups').doc(groupId);
    try {
      await userDocRef.collection('joiningGroup').doc(groupId).delete();
      await groupDocRef.collection('groupUsers').doc(userId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteGroup({String userId}) async {
    try {
      if (groupImageURL.isNotEmpty) {
        await FirebaseStorage.instance
            .ref()
            .child("groupImage/$groupId")
            .delete();
      }
      await firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroup')
          .doc(groupId)
          .delete();
      await firestore.collection('groups').doc(groupId).delete();
    } catch (e) {
      print(e);
    }
  }
}
