import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
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
}
