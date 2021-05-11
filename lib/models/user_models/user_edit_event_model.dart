import 'package:beet/objects/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEditEventModel extends ChangeNotifier {
  String ownerId = '';
  String eventId = '';
  String eventTitle = '';
  String eventPlace = '';
  String eventMemo = '';
  DateTime startingDateTime;
  DateTime endingDateTime;
  bool isLoading = false;
  bool isAllDay = false;
  bool isShowStartingPicker = false;
  bool isShowEndingPicker = false;
  Widget startingDateTimePickerBox = const SizedBox();
  Widget endingDateTimePickerBox = const SizedBox();
  CupertinoDatePickerMode cupertinoDatePickerMode =
      CupertinoDatePickerMode.dateAndTime;
  DocumentReference ownerDocRef;
  DateFormat tileDateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_JP');
  final DateFormat dateFormat = DateFormat('y-MM-dd');
  final DateFormat monthFormat = DateFormat('y-MM');
  final String userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({Event event}) {
    if (event.isAllDay) {
      tileDateFormat = DateFormat('y/M/d(E)', 'ja_JP');
      cupertinoDatePickerMode = CupertinoDatePickerMode.date;
      final DateTime start = event.startingDateTime;
      final DateTime end = event.endingDateTime;
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
    ownerId = event.ownerId;
    eventId = event.id;
    eventTitle = event.title;
    eventPlace = event.place;
    eventMemo = event.memo;
    isAllDay = event.isAllDay;
    startingDateTime = event.startingDateTime;
    endingDateTime = event.endingDateTime;
    ownerDocRef = ownerId == userId
        ? _firestore.collection('users').doc(userId)
        : _firestore.collection('groups').doc(ownerId);
    notifyListeners();
  }

  Future<void> updateEvent() async {
    if (eventTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }

    String month = '';
    List<DateTime> dateList = [];
    List<String> monthList = [];
    final String start = dateFormat.format(startingDateTime);
    final String end = dateFormat.format(endingDateTime);
    final int durationDays =
        DateTime.parse(end).difference(DateTime.parse(start)).inDays;
    final DateTime startingDate = DateTime(
      startingDateTime.year,
      startingDateTime.month,
      startingDateTime.day,
      12,
    ).toUtc();

    for (int i = 0; i <= durationDays; i++) {
      final DateTime date = startingDate.add(Duration(days: i));
      dateList.add(date);
    }

    dateList.forEach((date) {
      final String monthForm = monthFormat.format(date);
      if (monthForm != month) {
        month = monthForm;
        monthList.add(month);
      }
    });

    if (isAllDay) {
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
      await ownerDocRef.collection('events').doc(eventId).update({
        'title': eventTitle,
        'place': eventPlace,
        'memo': eventMemo,
        'isAllDay': isAllDay,
        'monthList': monthList,
        'dateList': dateList,
        'start': Timestamp.fromDate(startingDateTime),
        'end': Timestamp.fromDate(endingDateTime),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  void switchIsAllDay({bool value}) {
    isAllDay = value;
    if (isAllDay) {
      tileDateFormat = DateFormat('y/M/d(E)', 'ja_JP');
      cupertinoDatePickerMode = CupertinoDatePickerMode.date;
      startingDateTimePickerBox = const SizedBox();
      endingDateTimePickerBox = const SizedBox();
      isShowStartingPicker = false;
      isShowEndingPicker = false;
    } else {
      tileDateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_JP');
      cupertinoDatePickerMode = CupertinoDatePickerMode.dateAndTime;
      startingDateTimePickerBox = const SizedBox();
      endingDateTimePickerBox = const SizedBox();
      isShowStartingPicker = false;
      isShowEndingPicker = false;
    }
    notifyListeners();
  }

  void showStartingDateTimePicker() {
    if (!isShowStartingPicker) {
      if (isShowEndingPicker) {
        isShowEndingPicker = false;
        endingDateTimePickerBox = const SizedBox();
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
              endingDateTime = startingDateTime.add(const Duration(hours: 1));
            }
          },
        ),
      );
    } else {
      startingDateTimePickerBox = const SizedBox();
    }
    isShowStartingPicker = !isShowStartingPicker;
    notifyListeners();
  }

  void showEndingDateTimePicker() {
    if (!isShowEndingPicker) {
      if (isShowStartingPicker) {
        isShowStartingPicker = false;
        startingDateTimePickerBox = const SizedBox();
      }
      endingDateTimePickerBox = Container(
        height: 100.0,
        child: CupertinoDatePicker(
          mode: cupertinoDatePickerMode,
          use24hFormat: true,
          minuteInterval: 5,
          initialDateTime: endingDateTime,
          minimumDate: startingDateTime.add(const Duration(minutes: 5)),
          maximumDate: startingDateTime.add(const Duration(days: 1000)),
          onDateTimeChanged: (DateTime newDateTime) {
            if (isAllDay) {
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
              endingDateTime = startingDateTime.add(const Duration(hours: 1));
            }
          },
        ),
      );
    } else {
      endingDateTimePickerBox = const SizedBox();
    }
    isShowEndingPicker = !isShowEndingPicker;
    notifyListeners();
  }
}
