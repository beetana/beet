import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupAddSongModel extends ChangeNotifier {
  String songTitle = '';
  String songMemo = '';
  bool isLoading = false;
  int songPlayingTime = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addSong({String groupId}) async {
    if (songTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }

    try {
      await _firestore.collection('groups').doc(groupId).collection('songs').add({
        'title': songTitle,
        'minute': songPlayingTime,
        'memo': songMemo,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
