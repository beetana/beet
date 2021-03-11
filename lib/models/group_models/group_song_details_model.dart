import 'package:beet/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupSongDetailsModel extends ChangeNotifier {
  String groupID = '';
  Song song;
  String songID = '';
  String songTitle = '';
  String songMemo = '';
  int songPlayingTime;
  bool isLoading = false;

  void init({String groupID, Song song}) {
    this.groupID = groupID;
    this.song = song;
    this.songID = song.id;
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
          .doc(groupID)
          .collection('songs')
          .doc(songID)
          .get();
      song = Song.doc(songDoc);
      songID = song.id;
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
