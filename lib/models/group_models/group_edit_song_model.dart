import 'package:beet/objects/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEditSongModel extends ChangeNotifier {
  String groupId = '';
  String songId = '';
  String songTitle = '';
  String songMemo = '';
  int songPlayingTime;
  bool isLoading = false;
  // 曲の演奏時間(分) とりあえず12分まであれば充分かと
  final List<int> songPlayingTimes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void init({String groupId, Song song}) {
    this.groupId = groupId;
    songId = song.id;
    songTitle = song.title;
    songMemo = song.memo;
    songPlayingTime = song.playingTime;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateSong() async {
    if (songTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }

    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('songs')
          .doc(songId)
          .update({
        'title': songTitle,
        'memo': songMemo,
        'minute': songPlayingTime,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
