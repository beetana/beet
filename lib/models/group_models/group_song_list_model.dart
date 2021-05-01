import 'package:beet/constants.dart';
import 'package:beet/objects/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  String groupId = '';
  List<Song> songs = [];
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({String groupId}) async {
    startLoading();
    this.groupId = groupId;
    await fetchSongs();
    endLoading();
  }

  Future<void> fetchSongs() async {
    try {
      final QuerySnapshot songsQuery = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('songs')
          .orderBy('createdAt', descending: false)
          .get();
      songs = songsQuery.docs.map((doc) => Song.doc(doc)).toList();
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
    if (isSetListMode) {
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
    songs.forEach((song) {
      if (setList.contains(song)) {
        totalPlayTime += song.playingTime;
      } else {
        song.checkboxState = false;
      }
    });
    songCount = setList.where((item) => item is Song).length;
    notifyListeners();
  }
}
