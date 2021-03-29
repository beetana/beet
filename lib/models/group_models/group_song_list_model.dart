import 'package:beet/constants.dart';
import 'package:beet/objects/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  String groupId = '';
  List<Song> songList = [];
  List<String> selectedSongs = [];
  int songNum;
  int totalPlayTime;
  bool isLoading = false;
  bool isSetListMode = false;
  Text buttonText = Text(
    'セットリストを作成',
    style: TextStyle(
      color: kPrimaryColor,
    ),
  );
  Icon buttonIcon = Icon(
    Icons.playlist_add,
    color: kPrimaryColor,
  );
  MainAxisAlignment buttonAlignment = MainAxisAlignment.center;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String groupId}) async {
    startLoading();
    this.groupId = groupId;
    await getSongList();
    endLoading();
  }

  Future getSongList() async {
    try {
      final songQuery = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('songs')
          .orderBy('createdAt', descending: false)
          .get();
      songList = songQuery.docs.map((doc) => Song.doc(doc)).toList();
      selectedSongs = [];
      songNum = 0;
      totalPlayTime = 0;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  void changeMode() {
    isSetListMode = !isSetListMode;
    if (isSetListMode == true) {
      buttonText = Text(
        'キャンセル',
        style: TextStyle(
          color: kPrimaryColor,
        ),
      );
      buttonIcon = Icon(
        Icons.close,
        color: kPrimaryColor,
      );
      buttonAlignment = MainAxisAlignment.end;
    } else {
      buttonText = Text(
        'セットリストを作成',
        style: TextStyle(
          color: kPrimaryColor,
        ),
      );
      buttonIcon = Icon(
        Icons.playlist_add,
        color: kPrimaryColor,
      );
      buttonAlignment = MainAxisAlignment.center;
    }
    notifyListeners();
  }

  void selectSong({Song song}) {
    song.toggleCheckBoxState();
    if (song.checkboxState == true) {
      selectedSongs.add(song.title);
      totalPlayTime = totalPlayTime + song.playingTime;
    } else {
      selectedSongs.remove(song.title);
      totalPlayTime = totalPlayTime - song.playingTime;
    }
    songNum = selectedSongs
        .where((value) =>
            value != '-MC1-' &&
            value != '-MC2-' &&
            value != '-MC3-' &&
            value != '-MC4-' &&
            value != '-MC5-' &&
            value != '-MC6-' &&
            value != '-MC7-' &&
            value != '-MC8-' &&
            value != '-MC9-' &&
            value != '-MC10-')
        .length;
    notifyListeners();
  }
}
