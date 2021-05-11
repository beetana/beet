import 'package:beet/services/dynamic_links_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends ChangeNotifier {
  String userName = '';
  int currentIndex = 0;
  final DynamicLinksServices dynamicLinks = DynamicLinksServices();
  final String userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init({BuildContext context}) async {
    dynamicLinks.fetchLinkData(context: context);

    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    userName = userDoc['name'];
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
