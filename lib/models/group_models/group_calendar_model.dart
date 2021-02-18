import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nholiday_jp/nholiday_jp.dart';

class GroupCalendarModel extends ChangeNotifier {
  DateTime now = DateTime.now();
  DateTime selectedDay;
  List<Event> selectedEvents = [];
  Map<DateTime, List> events = {};
  Map<DateTime, List> holidays = {};
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');

  void init() {
    selectedDay = DateTime(now.year, now.month, now.day, 12);
  }

  Future getEvents({groupID, first, last}) async {
    events = {};
    List<Event> eventList;
    List<Event> eventsOfDay;
    DateTime firstDate = DateTime(first.year, first.month, first.day, 12);
    String monthForm = monthFormat.format(first);
    int durationDays = last.difference(first).inDays;

    try {
      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('events')
          .where('monthList', arrayContains: monthForm)
          .get();
      eventList = eventDoc.docs
          .map((doc) => Event(
                eventID: doc.id,
                myID: doc['myID'],
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
      for (int i = 0; i <= durationDays; i++) {
        DateTime date = firstDate.add(Duration(days: i));
        eventsOfDay =
            eventList.where((n) => n.dateList.contains(date)).toList() ?? [];
        events[date] = eventsOfDay;
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchHolidays({DateTime first}) {
    holidays = {};
    List<String> holidaysList;
    int year = first.year;
    int month = first.month;
    holidaysList = NHolidayJp.getByMonth(year, month)
        .map((holiday) => holiday.toString())
        .toList();
    if (holidaysList.isNotEmpty) {
      holidaysList.forEach((holiday) {
        List<String> splitHoliday = holiday.split(' ');
        String holidayDate = splitHoliday[0];
        List<String> holidayName = [splitHoliday[1]];
        int day = int.parse(holidayDate.split('/')[1]);
        holidays[DateTime(year, month, day, 12)] = holidayName;
      });
    }
  }

  void getSelectedEvents() {
    selectedEvents = events[selectedDay] ?? [];
    notifyListeners();
  }
}
