import 'package:beet/objects/mc.dart';
import 'package:beet/objects/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSetListModel extends ChangeNotifier {
  List<dynamic> setList = [];
  int songCount = 0;
  int totalPlayTime = 0;

  void init({List<dynamic> setList}) {
    this.setList = setList;
    songCount = setList.where((item) => item is Song).length;
    setList.forEach((item) {
      if (item is Song) {
        totalPlayTime += item.playingTime;
      }
    });
    notifyListeners();
  }

  void removeItem({dynamic item}) {
    setList.remove(item);
    if (item is Song) {
      songCount -= 1;
      totalPlayTime -= item.playingTime;
    }
    notifyListeners();
  }

  void addMC() {
    setList.add(MC());
    notifyListeners();
  }
}
