import 'package:beet/objects/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSongDetailsModel extends ChangeNotifier {
  String groupId = '';
  Song song;
  String songId = '';
  String songTitle = '';
  String songMemo = '';
  int songPlayingTime;
  bool isLoading = false;

  void init({String groupId, Song song}) {
    this.groupId = groupId;
    this.song = song;
    this.songId = song.id;
    this.songTitle = song.title;
    this.songMemo = song.memo;
    this.songPlayingTime = song.playingTime;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future getSong() async {
    try {
      DocumentSnapshot songDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('songs')
          .doc(songId)
          .get();
      song = Song.doc(songDoc);
      songId = song.id;
      songTitle = song.title;
      songMemo = song.memo;
      songPlayingTime = song.playingTime;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteSong() async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('songs')
          .doc(songId)
          .delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
