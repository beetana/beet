import 'package:beet/services/dynamic_links_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String userName = '';
  int currentIndex = 0;
  BuildContext context;
  final dynamicLinks = DynamicLinksServices();

  Future init({String userId, BuildContext context}) async {
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
