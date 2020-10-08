import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupAddEventModel extends ChangeNotifier {
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isLoading = false;
  bool isAllDay = false;
  bool isShowStartingPicker = false;
  bool isShowEndingPicker = false;
  Widget startingDateTimePickerBox = SizedBox();
  Widget endingDateTimePickerBox = SizedBox();
  CupertinoDatePickerMode cupertinoDatePickerMode =
      CupertinoDatePickerMode.dateAndTime;
  DateFormat tileDateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_JP');
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({dateTime}) {
    startingDateTime = dateTime;
    endingDateTime = dateTime.add(Duration(hours: 1));
  }

  void switchIsAllDay(bool value) {
    isAllDay = value;
    if (isAllDay == true) {
      tileDateFormat = DateFormat('y/M/d(E)', 'ja_JP');
      cupertinoDatePickerMode = CupertinoDatePickerMode.date;
      startingDateTimePickerBox = SizedBox();
      endingDateTimePickerBox = SizedBox();
      isShowStartingPicker = false;
      isShowEndingPicker = false;
    } else {
      tileDateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_JP');
      cupertinoDatePickerMode = CupertinoDatePickerMode.dateAndTime;
      startingDateTimePickerBox = SizedBox();
      endingDateTimePickerBox = SizedBox();
      isShowStartingPicker = false;
      isShowEndingPicker = false;
    }
    notifyListeners();
  }

  void showStartingDateTimePicker() {
    if (isShowStartingPicker == false) {
      startingDateTimePickerBox = Container(
        height: 100.0,
        child: CupertinoDatePicker(
          mode: cupertinoDatePickerMode,
          use24hFormat: true,
          minuteInterval: 5,
          initialDateTime: startingDateTime,
          minimumDate: DateTime(1980, 1, 1),
          maximumDate: DateTime(2050, 12, 31),
          onDateTimeChanged: (DateTime newDateTime) {
            if (isAllDay == true) {
              newDateTime = DateTime(
                newDateTime.year,
                newDateTime.month,
                newDateTime.day,
                12,
              );
            }
            startingDateTime = newDateTime;
            if (startingDateTime.isAfter(endingDateTime) ||
                startingDateTime.isAtSameMomentAs(endingDateTime)) {
              endingDateTime = startingDateTime.add(Duration(hours: 1));
            }
          },
        ),
      );
    } else {
      startingDateTimePickerBox = SizedBox();
    }
    isShowStartingPicker = !isShowStartingPicker;
    notifyListeners();
  }

  void showEndingDateTimePicker() {
    if (isShowEndingPicker == false) {
      endingDateTimePickerBox = Container(
        height: 100.0,
        child: CupertinoDatePicker(
          mode: cupertinoDatePickerMode,
          use24hFormat: true,
          minuteInterval: 5,
          initialDateTime: endingDateTime,
          minimumDate: startingDateTime.add(Duration(minutes: 5)),
          maximumDate: startingDateTime.add(Duration(days: 1000)),
          onDateTimeChanged: (DateTime newDateTime) {
            if (isAllDay == true) {
              newDateTime = DateTime(
                newDateTime.year,
                newDateTime.month,
                newDateTime.day,
                12,
              );
            }
            endingDateTime = newDateTime;
            if (startingDateTime.isAfter(endingDateTime) ||
                startingDateTime.isAtSameMomentAs(endingDateTime)) {
              endingDateTime = startingDateTime.add(Duration(hours: 1));
            }
          },
        ),
      );
    } else {
      endingDateTimePickerBox = SizedBox();
    }
    isShowEndingPicker = !isShowEndingPicker;
    notifyListeners();
  }

  Future addEvent({groupID}) async {
    if (eventTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    DateTime date;
    String month = '';
    List<DateTime> dateList = [];
    List<String> monthList = [];
    String start = dateFormat.format(startingDateTime);
    String end = dateFormat.format(endingDateTime);
    int durationDays =
        DateTime.parse(end).difference(DateTime.parse(start)).inDays;
    DateTime eventDate = DateTime(
      startingDateTime.year,
      startingDateTime.month,
      startingDateTime.day,
      12,
    ).toUtc();
    for (int i = 0; i <= durationDays; i++) {
      date = eventDate.add(Duration(days: i));
      dateList.add(date);
    }
    dateList.forEach((value) {
      String monthForm = monthFormat.format(value);
      if (monthForm != month) {
        month = monthForm;
        monthList.add(month);
      }
    });
    if (isAllDay == true) {
      startingDateTime = DateTime(
        startingDateTime.year,
        startingDateTime.month,
        startingDateTime.day,
        0,
      );
      endingDateTime = DateTime(
        endingDateTime.year,
        endingDateTime.month,
        endingDateTime.day,
        23,
        59,
        59,
      );
    }

    try {
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .collection('events')
          .add({
        'title': eventTitle,
        'place': eventPlace,
        'memo': eventMemo,
        'isAllDay': isAllDay,
        'monthList': monthList,
        'dateList': dateList,
        'start': Timestamp.fromDate(startingDateTime),
        'end': Timestamp.fromDate(endingDateTime),
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
