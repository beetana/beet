import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nholiday_jp/nholiday_jp.dart';
import 'package:beet/objects/content_owner.dart';

class UserCalendarModel extends ChangeNotifier {
  String userId = '';
  DateTime now = DateTime.now();
  DateTime first;
  DateTime last;
  DateTime selectedDay;
  List<Event> selectedEvents = [];
  Map<DateTime, List> events = {};
  Map<DateTime, List> holidays = {};
  Map<String, ContentOwner> eventPlanner = {};
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');

  void init({String userId}) {
    this.userId = userId;
    this.selectedDay = DateTime(now.year, now.month, now.day, 12);
  }

  Future getEvents() async {
    events = {};
    List<String> ownerIdList = [userId];
    List<Event> eventList;
    List<Event> eventsOfDay;
    DateTime firstDate = DateTime(first.year, first.month, first.day, 12);
    String monthForm = monthFormat.format(first);
    int durationDays = last.difference(first).inDays;

    try {
      QuerySnapshot joiningGroupDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('joiningGroup')
          .get();
      ownerIdList.addAll(joiningGroupDoc.docs.map((doc) => doc.id).toList());

      await fetchContentOwnerInfo(ownerIdList: ownerIdList);

      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collectionGroup('events')
          .where('ownerId', whereIn: ownerIdList)
          .where('monthList', arrayContains: monthForm)
          .get();

      eventList = eventDoc.docs.map((doc) => Event.doc(doc)).toList();
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

  Future fetchContentOwnerInfo({ownerIdList}) async {
    for (String id in ownerIdList) {
      if (id.length == 28) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(id).get();
        ContentOwner info = ContentOwner.doc(userDoc);
        eventPlanner[id] = info;
      } else {
        DocumentSnapshot groupDoc =
            await FirebaseFirestore.instance.collection('groups').doc(id).get();
        ContentOwner info = ContentOwner.doc(groupDoc);
        eventPlanner[id] = info;
      }
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

  void getSelectedEvents() {
    selectedEvents = events[selectedDay] ?? [];
    notifyListeners();
  }
}
