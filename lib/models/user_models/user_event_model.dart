import 'package:beet/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserEventModel extends ChangeNotifier {
  String eventID;
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  DateTime startingDateTime;
  DateTime endingDateTime;
  final dateFormat = DateFormat('y/M/d(E)  H:mm', 'ja_JP');
  final allDayDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  void init(Event event) {
    eventID = event.eventID;
    eventTitle = event.eventTitle;
    eventPlace = event.eventPlace;
    eventMemo = event.eventMemo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
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

  Widget eventMemoWidget() {
    if (eventMemo.isEmpty) {
      return Text('メモ');
    } else {
      return Text(eventMemo);
    }
  }
}
