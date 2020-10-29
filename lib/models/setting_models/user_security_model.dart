import 'package:flutter/material.dart';

class UserSecurityModel extends ChangeNotifier {
  String userID;
  bool isLoading = false;

  void init({userID}) {
    this.userID = userID;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }
}
