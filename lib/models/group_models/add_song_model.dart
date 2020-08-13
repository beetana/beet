import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSongModel extends ChangeNotifier {
  String songTitle = '';
  bool isLoading = false;
  int playingTime = 0;
  final List<int> playingTimes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addSong(groupID) async {
    if (songTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    try {
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .collection('songs')
          .add({
        'title': songTitle,
        'minute': playingTime,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
