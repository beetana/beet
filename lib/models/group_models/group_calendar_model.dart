import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nholiday_jp/nholiday_jp.dart';

class GroupCalendarModel extends ChangeNotifier {
  String groupId = '';
  late DateTime first; // カレンダーに表示されている月の最初の日
  late DateTime last; // その月の最後の日
  late DateTime selectedDay;
  late DateTime focusedDay;
  List<Event> selectedEvents = [];
  Map<DateTime, List<Event>> events = {}; // TableCalendarに表示するためには
  Map<DateTime, List> holidays = {}; // Map<DateTime, List>の形にする必要がある
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void init({required String groupId}) {
    this.groupId = groupId;
    final DateTime now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day, 12);
    focusedDay = selectedDay;
    first = DateTime(selectedDay.year, selectedDay.month, 1);
    last = DateTime(selectedDay.year, selectedDay.month + 1, 1).subtract(const Duration(days: 1));
  }

  Future<void> fetchEvents() async {
    events = {};
    final DateTime firstDate = DateTime(first.year, first.month, first.day, 12);
    final String monthForm = monthFormat.format(first);
    final int durationDays = last.difference(first).inDays;

    try {
      final QuerySnapshot eventsQuery =
          await _firestore.collection('groups').doc(groupId).collection('events').where('monthList', arrayContains: monthForm).get();

      final List<Event> eventList = eventsQuery.docs.map((doc) => Event.doc(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      eventList.sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));

      for (int i = 0; i <= durationDays; i++) {
        final DateTime date = firstDate.add(Duration(days: i));
        final List<Event> eventsOfDay = eventList.where((event) => event.dateList.contains(date)).toList() ?? [];
        events[date] = eventsOfDay;
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  // https://pub.dev/packages/nholiday_jp
  void fetchHolidays() {
    holidays = {};
    final int year = first.year;
    final int month = first.month;
    final List<String> holidaysList = NHolidayJp.getByMonth(year, month).map((holiday) => holiday.toString()).toList();

    if (holidaysList.isNotEmpty) {
      holidaysList.forEach((holiday) {
        final List<String> splitHoliday = holiday.split(' ');
        final String holidayDate = splitHoliday[0];
        final List<String> holidayName = [splitHoliday[1]];
        final int day = int.parse(holidayDate.split('/')[1]);
        holidays[DateTime(year, month, day, 12)] = holidayName;
      });
    }
  }

  void showEventsOfDay() {
    // selectedEventsの中身がカレンダーの下に表示される
    selectedEvents = events[selectedDay] ?? [];
    notifyListeners();
  }
}
