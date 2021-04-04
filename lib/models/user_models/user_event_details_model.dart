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
  bool isLoading = false;
  ContentOwner owner;
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
    this.ownerId = event.ownerId;
    this.eventId = event.id;
    this.eventTitle = event.title;
    this.eventPlace = event.place;
    this.eventMemo = event.memo;
    this.isAllDay = event.isAllDay;
    this.startingDateTime = event.startingDateTime;
    this.endingDateTime = event.endingDateTime;
    final ownerDocRef = ownerId == userId
        ? firestore.collection('users').doc(ownerId)
        : firestore.collection('groups').doc(ownerId);
    try {
      final ownerDoc = await ownerDocRef.get();
      this.owner = ContentOwner.doc(ownerDoc);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchEvent() async {
    final eventDocRef = this.ownerId == this.userId
        ? firestore
            .collection('users')
            .doc(this.userId)
            .collection('events')
            .doc(this.eventId)
        : firestore
            .collection('groups')
            .doc(this.ownerId)
            .collection('events')
            .doc(this.eventId);
    try {
      DocumentSnapshot eventDoc = await eventDocRef.get();
      this.event = Event.doc(eventDoc);
      this.ownerId = event.ownerId;
      this.eventId = event.id;
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
    final ownerDocRef = this.ownerId == this.userId
        ? firestore.collection('users').doc(this.userId)
        : firestore.collection('groups').doc(this.ownerId);
    try {
      await ownerDocRef.collection('events').doc(this.eventId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
