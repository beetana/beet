import 'package:beet/constants.dart';
import 'package:beet/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  List<Song> songList = [];
  List<String> selectedSongs;
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

  Future getSongList(groupID) async {
    isLoading = true;
    var songDoc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('songs')
        .orderBy('createdAt', descending: false)
        .get();
    songList = songDoc.docs
        .map((doc) => Song(
              id: doc.id,
              title: doc['title'],
              playingTime: doc['minute'],
            ))
        .toList();

    selectedSongs = [];
    songNum = 0;
    totalPlayTime = 0;
    isLoading = false;
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

  void selectSong(Song song) {
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
