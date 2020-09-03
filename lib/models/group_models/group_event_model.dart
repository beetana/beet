import 'package:beet/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupEventModel extends ChangeNotifier {
  String eventID;
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  bool isAllDay = false;
  DateTime startingDateTime;
  DateTime endingDateTime;
  final dateFormat = DateFormat('y/M/d(E)  H:mm', 'ja_JP');

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
    if (isAllDay == true) {
      return Container();
    } else {
      return Column(
        children: <Widget>[
          Text('開始  ${dateFormat.format(startingDateTime)}'),
          Text('終了  ${dateFormat.format(endingDateTime)}'),
        ],
      );
    }
  }
}

//Text('開始  ${dateFormat.format(event.startingDateTime)}'),
//Text('終了'),
//Text('終日'),
