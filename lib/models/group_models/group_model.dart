import 'package:beet/screens/group_screens/group_calendar_screen.dart';
import 'package:beet/screens/group_screens/group_main_screen.dart';
import 'package:beet/screens/group_screens/group_song_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupModel extends ChangeNotifier {
  int currentIndex = 0;
  String groupName = '';
  final List<Widget> switchBody = [
    GroupMainScreen(),
    GroupCalendarScreen(),
    GroupSongListScreen(),
  ];

  Future init({String groupID}) async {
    DocumentSnapshot groupDoc =
        await Firestore.instance.collection('groups').document(groupID).get();
    groupName = groupDoc['groupName'];
    notifyListeners();
  }

  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Widget switchFAB(int index) {
    if (index == 0) {
      return null;
    } else {
      return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
        onPressed: () {},
      );
    }
  }
}
