import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainModel extends ChangeNotifier {
  List<Event> eventList = [];
  String eventTitle;
  String eventPlace;
  String eventMemo;
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isLoading = false;

  Future getEventList(groupID) async {
    isLoading = true;
    var eventDoc = await Firestore.instance
        .collection('groups')
        .document(groupID)
        .collection('events')
        .getDocuments();
    eventList = eventDoc.documents
        .map((doc) => Event(
              eventID: doc.documentID,
              eventTitle: doc['title'],
              eventPlace: doc['place'],
              eventMemo: doc['memo'],
              startingDateTime: doc['start'].toDate(),
              endingDateTime: doc['end'].toDate(),
            ))
        .toList();
    isLoading = false;
    notifyListeners();
  }
}
