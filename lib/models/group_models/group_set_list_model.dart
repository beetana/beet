import 'package:beet/objects/song.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSetListModel extends ChangeNotifier {
  List<dynamic> setList;
  int songCount = 0;
  int totalPlayTime = 0;

  void init({List<dynamic> setList}) {
    this.setList = setList;
    this.songCount = setList.where((value) => value is Song).length;
    setList.forEach((item) {
      if (item is Song) {
        this.totalPlayTime += item.playingTime;
      }
    });
    notifyListeners();
  }

  void removeItem({dynamic item}) {
    this.setList.remove(item);
    if (item is Song) {
      this.songCount -= 1;
      this.totalPlayTime -= item.playingTime;
    }
    notifyListeners();
  }

  void addMC() {
    if (!setList.contains('-MC1-')) {
      setList.add('-MC1-');
    } else if (!setList.contains('-MC2-')) {
      setList.add(('-MC2-'));
    } else if (!setList.contains('-MC3-')) {
      setList.add(('-MC3-'));
    } else if (!setList.contains('-MC4-')) {
      setList.add(('-MC4-'));
    } else if (!setList.contains('-MC5-')) {
      setList.add(('-MC5-'));
    } else if (!setList.contains('-MC6-')) {
      setList.add(('-MC6-'));
    } else if (!setList.contains('-MC7-')) {
      setList.add(('-MC7-'));
    } else if (!setList.contains('-MC8-')) {
      setList.add(('-MC8-'));
    } else if (!setList.contains('-MC9-')) {
      setList.add(('-MC9-'));
    } else if (!setList.contains('-MC10-')) {
      setList.add(('-MC10-'));
    }
    notifyListeners();
  }
}
