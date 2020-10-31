import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nholiday_jp/nholiday_jp.dart';

class UserCalendarModel extends ChangeNotifier {
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

  Future getEvents({userID, first, last}) async {
    events = {};
    List<String> myIDList = [userID];
    List<Event> eventList;
    List<Event> eventsOfDay;
    DateTime firstDate = DateTime(first.year, first.month, first.day, 12);
    String monthForm = monthFormat.format(first);
    int durationDays = last.difference(first).inDays;

    try {
      QuerySnapshot joiningGroupDoc = await Firestore.instance
          .collection('users')
          .document(userID)
          .collection('joiningGroup')
          .getDocuments();
      myIDList.addAll(
          joiningGroupDoc.documents.map((doc) => doc.documentID).toList());

      //TODO whereIn句で10件までしかクエリできないので、参加できるグループを5つまでにするなどの対策が必要
      QuerySnapshot eventDoc = await Firestore.instance
          .collectionGroup('events')
          .where('myID', whereIn: myIDList)
          .where('monthList', arrayContains: monthForm)
          .getDocuments();

      eventList = eventDoc.documents
          .map((doc) => Event(
                eventID: doc.documentID,
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

//TODO 同じ日に祝日が被った場合、holidayNameの定義の仕方を変えないといけない
  void getHolidays({DateTime first}) {
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
        //TODO 祝日の名前を取得する時のことを考えるとDateTimeを12時で指定した方がいいかも
        holidays[DateTime(year, month, day)] = holidayName;
      });
    }
  }

  void getSelectedEvents() {
    selectedEvents = events[selectedDay] ?? [];
    notifyListeners();
  }
}
