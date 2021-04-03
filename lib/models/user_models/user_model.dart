import 'package:beet/services/dynamic_links_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserModel extends ChangeNotifier {
  String userName = '';
  int currentIndex = 0;
  BuildContext context;
  final dynamicLinks = DynamicLinksServices();
  final String userId = Auth.FirebaseAuth.instance.currentUser.uid;

  Future init({BuildContext context}) async {
    this.context = context;
    dynamicLinks.fetchLinkData(this.context);

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    userName = userDoc['name'];
    notifyListeners();
  }

  void onTabTapped(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      notifyListeners();
    }
  }
}
