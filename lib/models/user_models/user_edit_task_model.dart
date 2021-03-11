import 'package:beet/utilities/constants.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserEditTaskModel extends ChangeNotifier {
  String ownerID = '';
  String taskID = '';
  String taskTitle = '';
  String taskMemo = '';
  String dueDateText = '';
  bool isDecidedDueDate;
  bool isCompleted;
  List<String> assignedMembersID = [];
  List<String> usersID = [];
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

  void init({String userID, Task task}) async {
    startLoading();
    this.taskID = task.id;
    this.ownerID = task.ownerID;
    this.taskTitle = task.title;
    this.taskMemo = task.memo;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.isCompleted = task.isCompleted;
    this.dueDate = task.dueDate;
    this.dueDateText = task.isDecidedDueDate ? dateFormat.format(dueDate) : '';
    this.assignedMembersID =
        task.assignedMembersID.map((id) => id.toString()).toList();
    this.ownerDocRef = ownerID == userID
        ? firestore.collection('users').doc(userID)
        : firestore.collection('groups').doc(ownerID);
    try {
      if (ownerID == userID) {
        final userDoc = await ownerDocRef.get();
        groupMembers[userID] = User.doc(userDoc);
      } else {
        final groupUsers = await ownerDocRef.collection('groupUsers').get();
        this.usersID = groupUsers.docs.map((doc) => doc.id).toList();
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

  void assignPerson(userID) {
    if (assignedMembersID.contains(userID)) {
      assignedMembersID.remove(userID);
    } else {
      assignedMembersID.add(userID);
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
          FlatButton.icon(
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
      await ownerDocRef.collection('tasks').doc(taskID).update({
        'title': taskTitle,
        'memo': taskMemo,
        'isDecidedDueDate': isDecidedDueDate,
        'dueDate': isDecidedDueDate ? Timestamp.fromDate(dueDate) : null,
        'assignedMembersID': assignedMembersID,
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
