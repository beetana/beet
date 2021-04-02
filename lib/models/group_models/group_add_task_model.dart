import 'package:beet/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GroupAddTaskModel extends ChangeNotifier {
  String groupId = '';
  String taskTitle = '';
  String taskMemo = '';
  String dueDateText = '';
  bool isDecidedDueDate = true;
  List<String> assignedMembersId = [];
  List<String> usersId = [];
  List<String> userNames = [];
  List<String> userImageURLs = [];
  bool isLoading = false;
  bool isShowDueDatePicker = false;
  Widget dueDatePickerBox = const SizedBox();
  DateTime now = DateTime.now();
  DateTime dueDate;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String groupId}) async {
    startLoading();
    this.groupId = groupId;
    this.dueDate = DateTime(now.year, now.month, now.day, 12);
    this.dueDateText = dateFormat.format(dueDate);
    try {
      QuerySnapshot groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .get();
      usersId = (groupUsers.docs.map((doc) => doc.id).toList());
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

  void assignPerson(userId) {
    if (assignedMembersId.contains(userId)) {
      assignedMembersId.remove(userId);
    } else {
      assignedMembersId.add(userId);
    }
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
                this.isDecidedDueDate = true;
              },
            ),
          ),
          TextButton.icon(
            icon: const Icon(
              Icons.clear,
              color: Colors.black54,
            ),
            label: const Text(
              'クリア',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              this.dueDate = null;
              this.dueDateText = '';
              this.isDecidedDueDate = false;
              this.dueDatePickerBox = const SizedBox();
              this.isShowDueDatePicker = !isShowDueDatePicker;
              notifyListeners();
            },
          ),
        ],
      );
    } else {
      dueDatePickerBox = const SizedBox();
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
          .doc(groupId)
          .collection('tasks')
          .add({
        'title': taskTitle,
        'memo': taskMemo,
        'isDecidedDueDate': isDecidedDueDate,
        'dueDate': isDecidedDueDate ? Timestamp.fromDate(dueDate) : null,
        'assignedMembersId': assignedMembersId,
        'ownerId': groupId,
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
