import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupTaskDetailsModel extends ChangeNotifier {
  String groupId = '';
  Task task;
  String taskId = '';
  String taskTitle = '';
  String taskMemo = '';
  bool isDecidedDueDate;
  DateTime dueDate;
  List<dynamic> assignedMembersId = [];
  Map<String, User> groupMembers = {};
  bool isCompleted;
  bool isLoading = false;
  DocumentReference groupDocRef;
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String groupId, Task task}) async {
    startLoading();
    this.groupId = groupId;
    this.task = task;
    this.taskId = task.id;
    this.taskTitle = task.title;
    this.taskMemo = task.memo;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.dueDate = task.dueDate;
    this.assignedMembersId = task.assignedMembersId;
    this.isCompleted = task.isCompleted;
    this.groupDocRef = firestore.collection('groups').doc(groupId);
    try {
      final membersQuery = await groupDocRef.collection('members').get();
      final users = membersQuery.docs.map((doc) => User.doc(doc)).toList();
      users.forEach((user) {
        groupMembers[user.id] = user;
      });
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchTask() async {
    final taskDocRef = groupDocRef.collection('tasks').doc(taskId);
    try {
      DocumentSnapshot taskDoc = await taskDocRef.get();
      this.task = Task.doc(taskDoc);
      this.taskTitle = task.title;
      this.taskMemo = task.memo;
      this.isDecidedDueDate = task.isDecidedDueDate;
      this.dueDate = task.dueDate;
      this.assignedMembersId = task.assignedMembersId;
      this.isCompleted = task.isCompleted;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteTask() async {
    try {
      await groupDocRef.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
