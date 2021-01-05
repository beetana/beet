import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupID = '';
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
    final groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(groupID);
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userID);
    try {
      await groupDocRef.collection('groupUsers').doc(userID).delete();
      await userDocRef.collection('joiningGroup').doc(groupID).delete();
      await groupDocRef.update({
        'userCount': FieldValue.increment(-1),
      });
      await userDocRef.update({
        'groupCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
