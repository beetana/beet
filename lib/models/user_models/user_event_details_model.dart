import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserEventDetailsModel extends ChangeNotifier {
  Event event;
  String ownerId = '';
  String eventId = '';
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isOwn;
  bool isLoading = false;
  ContentOwner owner;
  DocumentReference ownerDocRef;
  final firestore = FirebaseFirestore.instance;
  final String userId = Auth.FirebaseAuth.instance.currentUser.uid;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({Event event}) async {
    startLoading();
    this.event = event;
    ownerId = event.ownerId;
    eventId = event.id;
    eventTitle = event.title;
    eventPlace = event.place;
    eventMemo = event.memo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
    isOwn = ownerId == userId;
    ownerDocRef = isOwn
        ? firestore.collection('users').doc(ownerId)
        : firestore.collection('groups').doc(ownerId);
    try {
      final ownerDoc = await ownerDocRef.get();
      owner = ContentOwner.doc(ownerDoc);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchEvent() async {
    try {
      final eventDoc =
          await ownerDocRef.collection('events').doc(eventId).get();
      event = Event.doc(eventDoc);
      ownerId = event.ownerId;
      eventId = event.id;
      eventTitle = event.title;
      eventPlace = event.place;
      eventMemo = event.memo;
      isAllDay = event.isAllDay;
      startingDateTime = event.startingDateTime;
      endingDateTime = event.endingDateTime;
      isOwn = ownerId == userId;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteEvent() async {
    try {
      await ownerDocRef.collection('events').doc(eventId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
