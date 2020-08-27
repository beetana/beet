import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupCalendarModel extends ChangeNotifier {
  DateTime now = DateTime.now();
  DateTime selectedDay;
  Map<DateTime, List> events;
  List eventList;
  final DateFormat dateFormat = DateFormat("y-MM-dd");

  void init() {
    selectedDay = DateTime(now.year, now.month, now.day, 12);
  }

  Future getEvents({groupID, date}) async {
    var eventDoc = await Firestore.instance
        .collection('groups')
        .document(groupID)
        .collection('events')
        .where(
          'dateList',
        )
        .getDocuments();
    eventList = eventDoc.documents
        .map((doc) => Event(
              eventID: doc.documentID,
              eventTitle: doc['title'],
              eventPlace: doc['place'],
              eventMemo: doc['memo'],
              startingDateTime: doc['start'].toDate(),
              endingDateTime: doc['end'].toDate(),
              dateList: doc['dateList'],
            ))
        .toList();
    events[date] = eventList;
    notifyListeners();
  }
}
