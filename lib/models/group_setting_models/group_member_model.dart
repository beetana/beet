import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupID;
  bool isLoading = false;

  void init({groupID}) {
    this.groupID = groupID;
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
