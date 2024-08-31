import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupEventDetailsModel extends ChangeNotifier {
  late Event event;
  String eventId = '';
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  late DateTime startingDateTime;
  late DateTime endingDateTime;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({required Event event}) {
    this.event = event;
    eventId = event.id;
    eventTitle = event.title;
    eventPlace = event.place;
    eventMemo = event.memo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
  }

  Future<void> fetchEvent({required String groupId}) async {
    try {
      final DocumentSnapshot eventDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('events')
          .doc(eventId)
          .get();
      event = Event.doc(eventDoc as DocumentSnapshot<Map<String, dynamic>>);
      eventId = event.id;
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

  Future<void> deleteEvent({required String groupId}) async {
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
