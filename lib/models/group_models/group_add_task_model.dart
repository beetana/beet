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
  List<String> membersId = [];
  List<String> membersName = [];
  List<String> membersImageURL = [];
  bool isLoading = false;
  bool isShowDueDatePicker = false;
  Widget dueDatePickerBox = const SizedBox();
  DateTime dueDate;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({String groupId}) async {
    startLoading();
    final DateTime now = DateTime.now();
    this.groupId = groupId;
    dueDate = DateTime(now.year, now.month, now.day, 12);
    dueDateText = dateFormat.format(dueDate);

    try {
      final QuerySnapshot membersQuery = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .get();
      membersId = (membersQuery.docs.map((doc) => doc.id).toList());
      membersName =
          (membersQuery.docs.map((doc) => doc['name'].toString()).toList());
      membersImageURL =
          (membersQuery.docs.map((doc) => doc['imageURL'].toString()).toList());
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  void assignPerson({String userId}) {
    if (assignedMembersId.contains(userId)) {
      assignedMembersId.remove(userId);
    } else {
      assignedMembersId.add(userId);
    }
    notifyListeners();
  }

  void showDueDatePicker() {
    if (!isShowDueDatePicker) {
      dueDatePickerBox = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 100.0,
            // DatePickerの細かい設定値に意味はない。必要なら変更可。
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: dueDate,
              minimumDate: DateTime(1980, 1, 1),
              maximumDate: DateTime(2050, 12, 31),
              onDateTimeChanged: (DateTime newDate) {
                dueDate = DateTime(newDate.year, newDate.month, newDate.day, 12);
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
      await _firestore.collection('groups').doc(groupId).collection('tasks').add({
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
