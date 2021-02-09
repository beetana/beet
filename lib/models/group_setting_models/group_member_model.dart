import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupID = '';
  String groupName = '';
  String myID = '';
  List<String> userIDs = [];
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

  Future init({groupID}) async {
    startLoading();
    this.groupID = groupID;
    myID = Auth.FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentSnapshot groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .get();
      groupName = groupDoc['name'];

      QuerySnapshot groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .get();
      userIDs = (groupUsers.docs.map((doc) => doc.id).toList());
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

  Future deleteMember({String userID}) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userID);
    final groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(groupID);
    try {
      await userDocRef.collection('joiningGroup').doc(groupID).delete();
      await groupDocRef.collection('groupUsers').doc(userID).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
