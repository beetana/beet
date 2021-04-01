import 'package:beet/constants.dart';
import 'package:beet/objects/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  String groupId = '';
  List<Song> songList = [];
  List<dynamic> setList = [];
  int songCount = 0;
  int totalPlayTime = 0;
  bool isLoading = false;
  bool isSetListMode = false;
  Text buttonText = const Text(
    'セットリストを作成',
    style: TextStyle(
      color: kPrimaryColor,
    ),
  );
  Icon buttonIcon = const Icon(
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
      setList = [];
      songCount = 0;
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
      buttonText = const Text(
        'キャンセル',
        style: TextStyle(
          color: kPrimaryColor,
        ),
      );
      buttonIcon = const Icon(
        Icons.close,
        color: kPrimaryColor,
      );
      buttonAlignment = MainAxisAlignment.end;
    } else {
      buttonText = const Text(
        'セットリストを作成',
        style: TextStyle(
          color: kPrimaryColor,
        ),
      );
      buttonIcon = const Icon(
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
      setList.add(song);
      songCount += 1;
      totalPlayTime += song.playingTime;
    } else {
      setList.remove(song);
      songCount -= 1;
      totalPlayTime -= song.playingTime;
    }
    notifyListeners();
  }

  void reselectSongs({List<dynamic> setList}) {
    this.setList = setList;
    totalPlayTime = 0;
    songList.forEach((song) {
      if (setList.contains(song)) {
        totalPlayTime += song.playingTime;
      } else {
        song.checkboxState = false;
      }
    });
    songCount = setList.where((value) => value is Song).length;
    notifyListeners();
  }
}
