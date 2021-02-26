import 'package:beet/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEditSongModel extends ChangeNotifier {
  String groupID = '';
  String songID = '';
  String songTitle = '';
  int songPlayingTime;
  bool isLoading = false;
  final List<int> songPlayingTimes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  void init({String groupID, Song song}) {
    this.groupID = groupID;
    this.songID = song.id;
    this.songTitle = song.title;
    this.songPlayingTime = song.playingTime;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future editSong() async {
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
        'minute': songPlayingTime,
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
