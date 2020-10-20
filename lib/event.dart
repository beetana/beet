import 'package:flutter/material.dart';

class Event {
  final String myID;
  final String eventID;
  final String eventTitle;
  final String eventPlace;
  final String eventMemo;
  final bool isAllDay;
  DateTime startingDateTime;
  DateTime endingDateTime;
  final List<dynamic> dateList;

  Event({
    @required this.eventID,
    @required this.myID,
    @required this.eventTitle,
    @required this.eventPlace,
    @required this.eventMemo,
    @required this.isAllDay,
    @required this.startingDateTime,
    @required this.endingDateTime,
    @required this.dateList,
  });
}
