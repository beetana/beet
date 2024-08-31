import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupTaskDetailsModel extends ChangeNotifier {
  String groupId = '';
  late Task task;
  String taskId = '';
  String taskTitle = '';
  String taskMemo = '';
  late bool isDecidedDueDate;
  late DateTime dueDate;
  List<dynamic> assignedMembersId = [];
  Map<String, User> groupMembers = {};
  late bool isCompleted;
  bool isLoading = false;
  late DocumentReference groupDocRef;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({required String groupId, required Task task}) async {
    startLoading();
    this.groupId = groupId;
    this.task = task;
    taskId = task.id;
    taskTitle = task.title;
    taskMemo = task.memo;
    isDecidedDueDate = task.isDecidedDueDate;
    dueDate = task.dueDate;
    assignedMembersId = task.assignedMembersId;
    isCompleted = task.isCompleted;
    groupDocRef = _firestore.collection('groups').doc(groupId);

    try {
      final QuerySnapshot membersQuery =
          await groupDocRef.collection('members').get();
      final List<User> users = membersQuery.docs
          .map((doc) => User.doc(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
      users.forEach((user) {
        groupMembers[user.id] = user;
      });
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future<void> fetchTask() async {
    try {
      final DocumentSnapshot taskDoc =
          await groupDocRef.collection('tasks').doc(taskId).get();
      task = Task.doc(taskDoc as DocumentSnapshot<Map<String, dynamic>>);
      taskTitle = task.title;
      taskMemo = task.memo;
      isDecidedDueDate = task.isDecidedDueDate;
      dueDate = task.dueDate;
      assignedMembersId = task.assignedMembersId;
      isCompleted = task.isCompleted;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future<void> deleteTask() async {
    try {
      await groupDocRef.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
