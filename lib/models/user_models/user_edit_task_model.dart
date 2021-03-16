import 'package:beet/utilities/constants.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserEditTaskModel extends ChangeNotifier {
  String ownerId = '';
  String taskId = '';
  String taskTitle = '';
  String taskMemo = '';
  String dueDateText = '';
  bool isDecidedDueDate;
  bool isCompleted;
  List<String> assignedMembersId = [];
  List<String> usersId = [];
  Map<String, User> groupMembers = {};
  bool isLoading = false;
  bool isShowDueDatePicker = false;
  Widget dueDatePickerBox = SizedBox();
  DateTime dueDate;
  DocumentReference ownerDocRef;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void init({String userId, Task task}) async {
    startLoading();
    this.taskId = task.id;
    this.ownerId = task.ownerId;
    this.taskTitle = task.title;
    this.taskMemo = task.memo;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.isCompleted = task.isCompleted;
    this.dueDate = task.dueDate;
    this.dueDateText = task.isDecidedDueDate ? dateFormat.format(dueDate) : '';
    this.assignedMembersId =
        task.assignedMembersId.map((id) => id.toString()).toList();
    this.ownerDocRef = ownerId == userId
        ? firestore.collection('users').doc(userId)
        : firestore.collection('groups').doc(ownerId);
    try {
      if (ownerId == userId) {
        final userDoc = await ownerDocRef.get();
        groupMembers[userId] = User.doc(userDoc);
      } else {
        final groupUsers = await ownerDocRef.collection('groupUsers').get();
        this.usersId = groupUsers.docs.map((doc) => doc.id).toList();
        final users = groupUsers.docs.map((doc) => User.doc(doc)).toList();
        users.forEach((user) {
          groupMembers[user.id] = user;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      endLoading();
    }
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
            icon: Icon(
              Icons.clear,
              color: Colors.black54,
            ),
            label: Text(
              '未定',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              this.dueDate = null;
              this.dueDateText = '';
              this.isDecidedDueDate = false;
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

  Future updateTask() async {
    if (taskTitle.isEmpty) {
      throw ('やることを入力してください');
    }
    try {
      await ownerDocRef.collection('tasks').doc(taskId).update({
        'title': taskTitle,
        'memo': taskMemo,
        'isDecidedDueDate': isDecidedDueDate,
        'dueDate': isDecidedDueDate ? Timestamp.fromDate(dueDate) : null,
        'assignedMembersId': assignedMembersId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
