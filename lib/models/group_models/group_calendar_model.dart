import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nholiday_jp/nholiday_jp.dart';

class GroupCalendarModel extends ChangeNotifier {
  String groupId = '';
  DateTime now = DateTime.now();
  DateTime first;
  DateTime last;
  DateTime selectedDay;
  List<Event> selectedEvents = [];
  Map<DateTime, List> events = {};
  Map<DateTime, List> holidays = {};
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');

  void init({String groupId}) {
    this.groupId = groupId;
    this.selectedDay = DateTime(now.year, now.month, now.day, 12);
  }

  Future fetchEvents() async {
    events = {};
    List<Event> eventList;
    List<Event> eventsOfDay;
    DateTime firstDate = DateTime(first.year, first.month, first.day, 12);
    String monthForm = monthFormat.format(first);
    int durationDays = last.difference(first).inDays;

    try {
      final eventQuery = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('events')
          .where('monthList', arrayContains: monthForm)
          .get();
      eventList = eventQuery.docs.map((doc) => Event.doc(doc)).toList();
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
      throw ('エラーが発生しました');
    }
  }

  void fetchHolidays() {
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

  void showEventsOfDay() {
    selectedEvents = events[selectedDay] ?? [];
    notifyListeners();
  }
}
