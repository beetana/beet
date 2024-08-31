import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserEventDetailsModel extends ChangeNotifier {
  late Event event;
  String ownerId = '';
  String eventId = '';
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  late DateTime startingDateTime;
  late DateTime endingDateTime;
  late bool isOwn;
  bool isLoading = false;
  ContentOwner? owner;
  late DocumentReference ownerDocRef;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({required Event event}) async {
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
    ownerDocRef = isOwn ? _firestore.collection('users').doc(ownerId) : _firestore.collection('groups').doc(ownerId);

    try {
      final DocumentSnapshot ownerDoc = await ownerDocRef.get();
      owner = ContentOwner.doc(ownerDoc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future<void> fetchEvent() async {
    try {
      final DocumentSnapshot eventDoc = await ownerDocRef.collection('events').doc(eventId).get();
      event = Event.doc(eventDoc as DocumentSnapshot<Map<String, dynamic>>);
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

  Future<void> deleteEvent() async {
    try {
      await ownerDocRef.collection('events').doc(eventId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
