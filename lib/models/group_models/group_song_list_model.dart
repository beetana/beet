import 'package:beet/song.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  List<String> songIDList = [];
  List<Song> songList = [];
  bool isSetListMode = false;

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
    notifyListeners();
  }

  void changeMode() {
    isSetListMode = !isSetListMode;
    notifyListeners();
  }

  void toggleCheck(Song song) {
    song.toggleCheckBoxState();
    notifyListeners();
  }
}
