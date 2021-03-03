import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserEventDetailsModel extends ChangeNotifier {
  Event event;
  String myID;
  String eventID;
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isLoading = false;
  final dateFormat = DateFormat('y/M/d(E)  H:mm', 'ja_JP');
  final allDayDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init(Event event) {
    this.event = event;
    myID = event.myID;
    eventID = event.eventID;
    eventTitle = event.eventTitle;
    eventPlace = event.eventPlace;
    eventMemo = event.eventMemo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
  }

  Future getEvent({String userID}) async {
    try {
      DocumentSnapshot eventDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('events')
          .doc(eventID)
          .get();
      event = Event(
        eventID: eventDoc.id,
        myID: eventDoc['myID'],
        eventTitle: eventDoc['title'],
        eventPlace: eventDoc['place'],
        eventMemo: eventDoc['memo'],
        isAllDay: eventDoc['isAllDay'],
        startingDateTime: eventDoc['start'].toDate(),
        endingDateTime: eventDoc['end'].toDate(),
        dateList: eventDoc['dateList'].map((date) => date.toDate()).toList(),
      );
      myID = event.myID;
      eventID = event.eventID;
      eventTitle = event.eventTitle;
      eventPlace = event.eventPlace;
      eventMemo = event.eventMemo;
      isAllDay = event.isAllDay;
      startingDateTime = event.startingDateTime;
      endingDateTime = event.endingDateTime;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteEvent({String userID}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('events')
          .doc(eventID)
          .delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Widget eventDateWidget() {
    String startingDay = allDayDateFormat.format(startingDateTime);
    String endingDay = allDayDateFormat.format(endingDateTime);

    if (isAllDay == false) {
      return Column(
        children: <Widget>[
          Text('開始  ${dateFormat.format(startingDateTime)}'),
          Text('終了  ${dateFormat.format(endingDateTime)}'),
        ],
      );
    } else if (isAllDay == true && startingDay == endingDay) {
      return Text(allDayDateFormat.format(startingDateTime));
    } else {
      return Column(
        children: <Widget>[
          Text('開始  ${allDayDateFormat.format(startingDateTime)}'),
          Text('終了  ${allDayDateFormat.format(endingDateTime)}'),
        ],
      );
    }
  }
}
