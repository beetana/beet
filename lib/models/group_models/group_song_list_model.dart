import 'package:beet/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  List<String> songIDList = [];
  List<Song> songList = [];
  List<Song> selectedSongs;
  int songNum;
  int totalPlayTime;
  bool isSetListMode = false;
  Text buttonText = Text('セットリストを作成');
  Icon buttonIcon = Icon(Icons.playlist_add, color: Colors.black54);
  MainAxisAlignment buttonAlignment = MainAxisAlignment.center;

  Future getSongList(groupID) async {
    var songDoc = await Firestore.instance
        .collection('groups')
        .document(groupID)
        .collection('songs')
        .orderBy('createdAt', descending: true)
        .getDocuments();
    songIDList = songDoc.documents.map((doc) => doc.documentID).toList();
    songList = songDoc.documents
        .map((doc) => Song(
              title: doc['title'].toString(),
              playTime: doc['minute'],
            ))
        .toList();
    selectedSongs = [];
    songNum = 0;
    totalPlayTime = 0;
    notifyListeners();
  }

  void changeMode() {
    isSetListMode = !isSetListMode;
    if (isSetListMode == true) {
      buttonText = Text('キャンセル');
      buttonIcon = Icon(Icons.close, color: Colors.black54);
      buttonAlignment = MainAxisAlignment.end;
    } else {
      buttonText = Text('セットリストを作成');
      buttonIcon = Icon(Icons.playlist_add, color: Colors.black54);
      buttonAlignment = MainAxisAlignment.center;
    }
    notifyListeners();
  }

  void selectSong(Song song) {
    song.toggleCheckBoxState();
    if (song.checkboxState == true) {
      selectedSongs.add(song);
      totalPlayTime = totalPlayTime + song.playTime;
    } else {
      selectedSongs.remove(song);
      totalPlayTime = totalPlayTime - song.playTime;
    }
    songNum = selectedSongs.length;
    notifyListeners();
  }
}
