import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupAddEventModel extends ChangeNotifier {
  String eventTitle = '';
  String eventPlace = '';
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
          onDateTimeChanged: (DateTime newDateTime) {
            startingDateTime = newDateTime;
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
        'start': Timestamp.fromDate(startingDateTime),
        'end': Timestamp.fromDate(endingDateTime),
      });
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
