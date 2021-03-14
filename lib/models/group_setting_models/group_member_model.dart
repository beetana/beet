import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupId = '';
  String groupName = '';
  String myId = '';
  List<String> usersId = [];
  List<String> userNames = [];
  List<String> userImageURLs = [];
  bool isLoading = false;

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
    myId = Auth.FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentSnapshot groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();
      groupName = groupDoc['name'];

      QuerySnapshot groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .get();
      usersId = (groupUsers.docs.map((doc) => doc.id).toList());
      userNames =
          (groupUsers.docs.map((doc) => doc['name'].toString()).toList());
      userImageURLs =
          (groupUsers.docs.map((doc) => doc['imageURL'].toString()).toList());
    } catch (e) {
      print(e);
    } finally {
      endLoading();
    }
  }

  Future deleteMember({String userId}) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    final groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    try {
      await userDocRef.collection('joiningGroup').doc(groupId).delete();
      await groupDocRef.collection('groupUsers').doc(userId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
