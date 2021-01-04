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
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('songs')
          .doc(songID)
          .update({
        'title': songTitle,
        'minute': playingTime,
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteSong({groupID, songID}) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('songs')
          .doc(songID)
          .delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
