import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongEditModel extends ChangeNotifier {
  String songTitle;
  int playingTime;
  bool isLoading = false;
  final List<int> playingTimes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future editSong({groupID, songID}) async {
    if (songTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    try {
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .collection('songs')
          .document(songID)
          .updateData({
        'title': songTitle,
        'minute': playingTime,
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
