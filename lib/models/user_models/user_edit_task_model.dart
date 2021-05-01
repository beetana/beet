import 'package:beet/constants.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

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
  Widget dueDatePickerBox = const SizedBox();
  DateTime dueDate;
  DocumentReference ownerDocRef;
  final DateFormat dateFormat = DateFormat('y/M/d(E)', 'ja_JP');
  final String userId = Auth.FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({Task task}) async {
    startLoading();
    taskId = task.id;
    ownerId = task.ownerId;
    taskTitle = task.title;
    taskMemo = task.memo;
    isDecidedDueDate = task.isDecidedDueDate;
    isCompleted = task.isCompleted;
    dueDate = task.dueDate;
    dueDateText = task.isDecidedDueDate ? dateFormat.format(dueDate) : '';
    assignedMembersId =
        task.assignedMembersId.map((id) => id.toString()).toList();
    ownerDocRef = ownerId == userId
        ? _firestore.collection('users').doc(userId)
        : _firestore.collection('groups').doc(ownerId);
    try {
      if (ownerId == userId) {
        final DocumentSnapshot userDoc = await ownerDocRef.get();
        groupMembers[userId] = User.doc(userDoc);
      } else {
        final QuerySnapshot membersQuery =
            await ownerDocRef.collection('members').get();
        usersId = membersQuery.docs.map((doc) => doc.id).toList();
        final List<User> users =
            membersQuery.docs.map((doc) => User.doc(doc)).toList();
        users.forEach((user) {
          groupMembers[user.id] = user;
        });
      }
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

  Future<void> updateTask() async {
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
