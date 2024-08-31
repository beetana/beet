import 'package:beet/objects/guest_mode_song.dart';
import 'package:beet/objects/mc.dart';
import 'package:beet/objects/set_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UseAsGuestModel extends ChangeNotifier {
  String title = '';
  List<SetList> setList = []; // setListに入るのはMCもしくはString

  void addSong() {
    setList.add(GuestModeSong(title));
    title = '';
    notifyListeners();
  }

  void addMC() {
    setList.add(MC());
    notifyListeners();
  }

  void removeItem({required SetList item}) {
    this.setList.remove(item);
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
