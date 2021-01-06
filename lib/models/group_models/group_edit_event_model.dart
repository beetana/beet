import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupEditEventModel extends ChangeNotifier {
  String myID;
  String eventID;
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

  void init({event}) {
    if (event.isAllDay == true) {
      tileDateFormat = DateFormat('y/M/d(E)', 'ja_JP');
      cupertinoDatePickerMode = CupertinoDatePickerMode.date;
      DateTime start = event.startingDateTime;
      DateTime end = event.endingDateTime;
      event.startingDateTime = DateTime(
        start.year,
        start.month,
        start.day,
        12,
      );
      event.endingDateTime = DateTime(
        end.year,
        end.month,
        end.day,
        12,
      );
      if (event.startingDateTime == event.endingDateTime) {
        event.endingDateTime = DateTime(
          end.year,
          end.month,
          end.day,
          13,
        );
      }
    }
    myID = event.myID;
    eventID = event.eventID;
    eventTitle = event.eventTitle;
    eventPlace = event.eventPlace;
    eventMemo = event.eventMemo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
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
      if (isShowEndingPicker == true) {
        isShowEndingPicker = false;
        endingDateTimePickerBox = SizedBox();
      }
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
      if (isShowStartingPicker == true) {
        isShowStartingPicker = false;
        startingDateTimePickerBox = SizedBox();
      }
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

  Future editEvent({groupID}) async {
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
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('events')
          .doc(eventID)
          .set({
        'myID': myID,
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
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
