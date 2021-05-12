import 'package:beet/objects/mc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UseAsGuestModel extends ChangeNotifier {
  String title = '';
  List<dynamic> setList = []; // setListに入るのはMCもしくはString

  void addSong() {
    setList.add(title);
    title = '';
    notifyListeners();
  }

  void addMC() {
    setList.add(MC());
    notifyListeners();
  }

  void removeItem({dynamic item}) {
    this.setList.remove(item);
    notifyListeners();
  }
}
