import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainModel extends ChangeNotifier {
  List<Event> eventList = [];
  bool isLoading = false;

  Future getEventList(groupID) async {
    final currentTimestamp = Timestamp.fromDate(DateTime.now());
    isLoading = true;
    try {
      QuerySnapshot eventDoc = await Firestore.instance
          .collection('groups')
          .document(groupID)
          .collection('events')
          .where('end', isGreaterThan: currentTimestamp)
          .getDocuments();
      eventList = eventDoc.documents
          .map((doc) => Event(
                eventID: doc.documentID,
                eventTitle: doc['title'],
                eventPlace: doc['place'],
                eventMemo: doc['memo'],
                startingDateTime: doc['start'].toDate(),
                endingDateTime: doc['end'].toDate(),
                dateList: doc['dateList'].map((date) => date.toDate()).toList(),
              ))
          .toList();
      eventList
          .sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
