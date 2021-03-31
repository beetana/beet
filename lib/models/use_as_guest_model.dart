import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UseAsGuestModel extends ChangeNotifier {
  String title = '';
  List<String> setList = [];

  void addSong() {
    setList.add(title);
    title = '';
    notifyListeners();
  }

  void removeItem({String item}) {
    this.setList.remove(item);
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
