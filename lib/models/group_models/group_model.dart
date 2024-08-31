import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupModel extends ChangeNotifier {
  String groupName = '';
  int currentIndex = 0; // 今現在表示している画面のindex
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init({required String groupId}) async {
    try {
      final DocumentSnapshot groupDoc =
          await _firestore.collection('groups').doc(groupId).get();
      groupName = groupDoc['name'];
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  // 選択したタブのindex番号を代入すると、それに対応した画面に切り替わる
  void onTabTapped(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }
}
