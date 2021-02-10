import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupAddTaskModel extends ChangeNotifier {
  String groupID = '';
  String taskTitle = '';
  String dueDateText = '';
  List<String> assignedMemberIDs = [];
  List<String> userIDs = [];
  List<String> userNames = [];
  List<String> userImageURLs = [];
  bool isLoading = false;
  bool isShowDueDatePicker = false;
  Widget dueDatePickerBox = SizedBox();
  DateTime now = DateTime.now();
  DateTime dueDate;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({String groupID}) async {
    startLoading();
    this.groupID = groupID;
    this.dueDate = DateTime(now.year, now.month, now.day, 12);
    this.dueDateText = dateFormat.format(dueDate);
    try {
      QuerySnapshot groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .get();
      userIDs = (groupUsers.docs.map((doc) => doc.id).toList());
      userNames =
          (groupUsers.docs.map((doc) => doc['name'].toString()).toList());
      userImageURLs =
          (groupUsers.docs.map((doc) => doc['imageURL'].toString()).toList());
    } catch (e) {
      print(e);
    } finally {
      endLoading();
    }
  }

  void assignPerson(userID) {
    if (assignedMemberIDs.contains(userID)) {
      assignedMemberIDs.remove(userID);
    } else {
      assignedMemberIDs.add(userID);
    }
    print(assignedMemberIDs);
    notifyListeners();
  }

  void showDueDatePicker() {
    if (isShowDueDatePicker == false) {
      dueDatePickerBox = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 100.0,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: dueDate,
              minimumDate: DateTime(1980, 1, 1),
              maximumDate: DateTime(2050, 12, 31),
              onDateTimeChanged: (DateTime newDate) {
                this.dueDate =
                    DateTime(newDate.year, newDate.month, newDate.day, 12);
                this.dueDateText = dateFormat.format(dueDate);
              },
            ),
          ),
          FlatButton.icon(
            icon: Icon(
              Icons.clear,
              color: Colors.black54,
            ),
            label: Text(
              '未定',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () {
              this.dueDate = DateTime(now.year, now.month, now.day, 12);
              this.dueDateText = '';
              this.dueDatePickerBox = SizedBox();
              this.isShowDueDatePicker = !isShowDueDatePicker;
              notifyListeners();
            },
          ),
        ],
      );
    } else {
      dueDatePickerBox = SizedBox();
    }
    isShowDueDatePicker = !isShowDueDatePicker;
    notifyListeners();
  }

  Future addTask() async {
    if (taskTitle.isEmpty) {
      throw ('やることを入力してください');
    }
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('tasks')
          .add({
        'title': taskTitle,
        'dueDate': Timestamp.fromDate(dueDate),
        'assignedMemberIDs': assignedMemberIDs,
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
