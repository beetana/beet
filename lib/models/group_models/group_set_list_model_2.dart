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

  void dateUndecided() {
    if (isShowEventDatePicker == true) {
      eventDatePickerBox = SizedBox();
      isShowEventDatePicker = false;
    }
    eventDateText = '';
    notifyListeners();
  }

  void showEventDatePicker() {
    if (isShowEventDatePicker == false) {
      eventDatePickerBox = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
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
          ),
          SizedBox(height: 16.0),
          FlatButton.icon(
            icon: Icon(
              Icons.clear,
              color: Colors.red[300],
            ),
            label: Text(
              '未定',
              style: TextStyle(color: Colors.red[300]),
            ),
            onPressed: () {
              eventDate = DateTime.now();
              eventDateText = '';
              eventDatePickerBox = SizedBox();
              isShowEventDatePicker = !isShowEventDatePicker;
              notifyListeners();
            },
          ),
        ],
      );
    } else {
      eventDatePickerBox = SizedBox();
    }
    isShowEventDatePicker = !isShowEventDatePicker;
    notifyListeners();
  }
}
