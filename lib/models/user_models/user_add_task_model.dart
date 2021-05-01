import 'package:beet/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAddTaskModel extends ChangeNotifier {
  String taskTitle = '';
  String taskMemo = '';
  String dueDateText = '';
  bool isDecidedDueDate = true;
  List<String> assignedUserId = [];
  bool isLoading = false;
  bool isShowDueDatePicker = false;
  Widget dueDatePickerBox = const SizedBox();
  DateTime dueDate;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');
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

  void init() {
    final DateTime now = DateTime.now();
    assignedUserId = [userId];
    dueDate = DateTime(now.year, now.month, now.day, 12);
    dueDateText = dateFormat.format(dueDate);
    notifyListeners();
  }

  void showDueDatePicker() {
    if (!isShowDueDatePicker) {
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
                dueDate =
                    DateTime(newDate.year, newDate.month, newDate.day, 12);
                dueDateText = dateFormat.format(dueDate);
                isDecidedDueDate = true;
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
              dueDate = null;
              dueDateText = '';
              isDecidedDueDate = false;
              dueDatePickerBox = const SizedBox();
              isShowDueDatePicker = !isShowDueDatePicker;
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

  Future<void> addTask() async {
    if (taskTitle.isEmpty) {
      throw ('やることを入力してください');
    }
    try {
      await _firestore.collection('users').doc(userId).collection('tasks').add({
        'title': taskTitle,
        'memo': taskMemo,
        'isDecidedDueDate': isDecidedDueDate,
        'dueDate': isDecidedDueDate ? Timestamp.fromDate(dueDate) : null,
        'assignedMembersId': assignedUserId,
        'ownerId': userId,
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
