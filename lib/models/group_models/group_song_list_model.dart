import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSongListModel extends ChangeNotifier {
  List songList = [];

  Future getSongList(groupID) async {
    var songDoc = await Firestore.instance
        .collection('groups')
        .document(groupID)
        .collection('songs')
        .getDocuments();

    songList = (songDoc.documents.map((doc) => doc['title']).toList());
    notifyListeners();
  }
}
