import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserCalendarModel extends ChangeNotifier {
  DateTime now = DateTime.now();
  DateTime selectedDay;
  Map<DateTime, List> events = {};
  List<Event> eventList = [];
  List<Event> selectedEvents = [];
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');

  void init() {
    selectedDay = DateTime(now.year, now.month, now.day, 12);
  }

  Future getEvents({userID, first, last}) async {
    DateTime firstDate = DateTime(first.year, first.month, first.day, 12);
    String monthForm = monthFormat.format(first);
    int durationDays = last.difference(first).inDays;
    List<Event> calendarEvent = [];
    events = {};

    try {
      var eventDoc = await Firestore.instance
          .collection('users')
          .document(userID)
          .collection('events')
          .where('monthList', arrayContains: monthForm)
          .getDocuments();
      eventList = eventDoc.documents
          .map((doc) => Event(
                eventID: doc.documentID,
                eventTitle: doc['title'],
                eventPlace: doc['place'],
                eventMemo: doc['memo'],
                isAllDay: doc['isAllDay'],
                startingDateTime: doc['start'].toDate(),
                endingDateTime: doc['end'].toDate(),
                dateList: doc['dateList'].map((date) => date.toDate()).toList(),
              ))
          .toList();
      eventList
          .sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
      eventList.forEach((event) {
        if (event.isAllDay == true) {
          DateTime start = event.startingDateTime;
          DateTime end = event.endingDateTime;
          event.startingDateTime = DateTime(
            start.year,
            start.month,
            start.day,
            12,
          );
          event.endingDateTime = DateTime(
            end.year,
            end.month,
            end.day,
            12,
          );
        }
      });
      for (int i = 0; i <= durationDays; i++) {
        DateTime date = firstDate.add(Duration(days: i));
        calendarEvent =
            eventList.where((n) => n.dateList.contains(date)).toList() ?? [];
        events[date] = calendarEvent;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void getSelectedEvents() {
    selectedEvents = events[selectedDay] ?? [];
    notifyListeners();
  }
}
