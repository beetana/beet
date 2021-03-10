import 'package:beet/content_owner.dart';
import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserEventDetailsModel extends ChangeNotifier {
  String userID = '';
  Event event;
  String ownerID = '';
  String eventID = '';
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isLoading = false;
  ContentOwner owner;
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String userID, Event event}) async {
    startLoading();
    this.userID = userID;
    this.event = event;
    this.ownerID = event.ownerID;
    this.eventID = event.id;
    this.eventTitle = event.title;
    this.eventPlace = event.place;
    this.eventMemo = event.memo;
    this.isAllDay = event.isAllDay;
    this.startingDateTime = event.startingDateTime;
    this.endingDateTime = event.endingDateTime;
    final ownerDocRef = ownerID == userID
        ? firestore.collection('users').doc(ownerID)
        : firestore.collection('groups').doc(ownerID);
    try {
      final ownerDoc = await ownerDocRef.get();
      this.owner = ContentOwner.doc(ownerDoc);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getEvent({String userID}) async {
    try {
      DocumentSnapshot eventDoc = await firestore
          .collection('users')
          .doc(userID)
          .collection('events')
          .doc(eventID)
          .get();
      event = Event.doc(eventDoc);
      ownerID = event.ownerID;
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

  Future deleteEvent() async {
    try {
      await firestore
          .collection('users')
          .doc(userID)
          .collection('events')
          .doc(eventID)
          .delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
