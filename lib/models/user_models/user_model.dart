import 'package:beet/dynamic_links_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userName = '';
  int currentIndex = 0;
  BuildContext context;
  final dynamicLinks = DynamicLinksServices();

  Future init({String userID, BuildContext context}) async {
    this.context = context;
    dynamicLinks.fetchLinkData(this.context);

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
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
