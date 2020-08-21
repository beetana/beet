import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupAddEventModel extends ChangeNotifier {
  DateTime currentTime = DateTime.now();
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

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({dateTime}) {
    startingDateTime = dateTime;
    endingDateTime = dateTime.add(Duration(hours: 1));
  }

  void switchIsAllDay(bool value) {
    isAllDay = value;
    notifyListeners();
  }

  void showStartingDateTimePicker() {
    if (isShowStartingPicker == false) {
      startingDateTimePickerBox = Container(
        height: 100.0,
        child: CupertinoDatePicker(
          use24hFormat: true,
          minuteInterval: 5,
          initialDateTime: startingDateTime,
          minimumDate: DateTime(1980, 1, 1),
          maximumDate: DateTime(2050, 12, 31),
          onDateTimeChanged: (DateTime newDateTime) {
            startingDateTime = newDateTime;
            endingDateTime = startingDateTime.add(Duration(hours: 1));
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
          use24hFormat: true,
          minuteInterval: 5,
          initialDateTime: endingDateTime,
          minimumDate: startingDateTime.add(Duration(minutes: 5)),
          maximumDate: startingDateTime.add(Duration(days: 1000)),
          onDateTimeChanged: (DateTime newDateTime) {
            endingDateTime = newDateTime;
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
    try {
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .collection('events')
          .add({
        'title': eventTitle,
        'place': eventPlace,
        'memo': eventMemo,
        'start': Timestamp.fromDate(startingDateTime),
        'end': Timestamp.fromDate(endingDateTime),
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
