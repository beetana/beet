import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDateWidget extends StatelessWidget {
  final bool isAllDay;
  final DateTime startingDateTime;
  final DateTime endingDateTime;
  final DateFormat dateFormat = DateFormat('y/M/d(E)  H:mm', 'ja_JP');
  final DateFormat allDayDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  EventDateWidget({
    this.isAllDay,
    this.startingDateTime,
    this.endingDateTime,
  });

  @override
  Widget build(BuildContext context) {
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
