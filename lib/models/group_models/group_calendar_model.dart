import 'package:flutter/material.dart';

class GroupCalendarModel extends ChangeNotifier {
  DateTime now = DateTime.now();
  DateTime selectedDay;
  void init() {
    selectedDay = DateTime(now.year, now.month, now.day, 12);
  }
}
