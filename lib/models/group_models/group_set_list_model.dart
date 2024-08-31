import 'package:beet/objects/mc.dart';
import 'package:beet/objects/set_list.dart';
import 'package:beet/objects/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSetListModel extends ChangeNotifier {
  List<SetList> setList = []; // setListに入るのはSongもしくはMC
  int songCount = 0;
  int totalPlayTime = 0;

  void init({required List<SetList> setList}) {
    this.setList = setList;
    songCount = setList.where((item) => item is Song).length;
    setList.forEach((item) {
      if (item is Song) {
        totalPlayTime += item.playingTime;
      }
    });
    notifyListeners();
  }

  void addMC() {
    setList.add(MC());
    notifyListeners();
  }

  void removeItem({required SetList item}) {
    setList.remove(item);
    if (item is Song) {
      songCount -= 1;
      totalPlayTime -= item.playingTime;
    }
    notifyListeners();
  }

  void reorderItems({required int oldIndex, required int newIndex}) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = setList.removeAt(oldIndex);
    setList.insert(newIndex, item);
    notifyListeners();
  }
}
