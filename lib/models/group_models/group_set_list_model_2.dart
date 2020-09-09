import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupSetListModel2 extends ChangeNotifier {
  DateTime eventDate;
  String eventTitle = '';
  String eventPlace = '';
  String eventDateText = '';
  bool isLoading = false;
  bool isShowEventDatePicker = false;
  Widget eventDatePickerBox = SizedBox();
  final eventDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  void init() {
    eventDate = DateTime.now();
    eventDateText = eventDateFormat.format(eventDate);
  }

  void showEventDatePicker() {
    if (isShowEventDatePicker == false) {
      eventDatePickerBox = Container(
        height: 100.0,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: eventDate,
          minimumDate: DateTime(1980, 1, 1),
          maximumDate: DateTime(2050, 12, 31),
          onDateTimeChanged: (DateTime newDate) {
            eventDate = newDate;
            eventDateText = eventDateFormat.format(eventDate);
          },
        ),
      );
    } else {
      eventDatePickerBox = SizedBox();
    }
    isShowEventDatePicker = !isShowEventDatePicker;
    notifyListeners();
  }
}
