import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSongModel extends ChangeNotifier {
  String songTitle = '';
  bool isLoading = false;

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
          .add({'title': songTitle});
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
