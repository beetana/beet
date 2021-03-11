import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupEventDetailsModel extends ChangeNotifier {
  Event event;
  String eventID;
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init(Event event) {
    this.event = event;
    eventID = event.id;
    eventTitle = event.title;
    eventPlace = event.place;
    eventMemo = event.memo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
  }

  Future getEvent({String groupID}) async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('events')
          .doc(eventID)
          .get();
      event = Event.doc(eventDoc);
      eventID = event.id;
      eventTitle = event.title;
      eventPlace = event.place;
      eventMemo = event.memo;
      isAllDay = event.isAllDay;
      startingDateTime = event.startingDateTime;
      endingDateTime = event.endingDateTime;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteEvent({String groupID}) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('events')
          .doc(eventID)
          .delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
