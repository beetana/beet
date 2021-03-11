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

  Future getEvent() async {
    final eventDocRef = this.ownerID == this.userID
        ? firestore
            .collection('users')
            .doc(this.userID)
            .collection('events')
            .doc(this.eventID)
        : firestore
            .collection('groups')
            .doc(this.ownerID)
            .collection('events')
            .doc(this.eventID);
    try {
      DocumentSnapshot eventDoc = await eventDocRef.get();
      this.event = Event.doc(eventDoc);
      this.ownerID = event.ownerID;
      this.eventID = event.id;
      this.eventTitle = event.title;
      this.eventPlace = event.place;
      this.eventMemo = event.memo;
      this.isAllDay = event.isAllDay;
      this.startingDateTime = event.startingDateTime;
      this.endingDateTime = event.endingDateTime;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteEvent() async {
    final ownerDocRef = this.ownerID == this.userID
        ? firestore.collection('users').doc(this.userID)
        : firestore.collection('groups').doc(this.ownerID);
    try {
      await ownerDocRef.collection('events').doc(this.eventID).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
