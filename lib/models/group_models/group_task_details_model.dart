import 'package:beet/task.dart';
import 'package:beet/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupTaskDetailsModel extends ChangeNotifier {
  String groupID = '';
  Task task;
  String taskID = '';
  String taskTitle = '';
  bool isDecidedDueDate;
  DateTime dueDate;
  List<dynamic> assignedMembersID = [];
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

  Future init({String groupID, Task task}) async {
    startLoading();
    this.groupID = groupID;
    this.task = task;
    this.taskID = task.id;
    this.taskTitle = task.title;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.dueDate = task.dueDate;
    this.assignedMembersID = task.assignedMembersID;
    this.isCompleted = task.isCompleted;
    groupDocRef = firestore.collection('groups').doc(groupID);
    try {
      QuerySnapshot groupUsers =
          await groupDocRef.collection('groupUsers').get();
      final users = groupUsers.docs.map((doc) => User.doc(doc)).toList();
      users.forEach((user) {
        groupMembers[user.id] = user;
      });
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getTask({Task task}) async {
    final taskDocRef = groupDocRef.collection('tasks').doc(task.id);
    try {
      DocumentSnapshot taskDoc = await taskDocRef.get();
      this.task = Task(
        id: taskDoc.id,
        title: taskDoc['title'],
        isDecidedDueDate: taskDoc['isDecidedDueDate'],
        dueDate: taskDoc['isDecidedDueDate']
            ? taskDoc['dueDate'].toDate()
            : DateTime.now(),
        assignedMembersID: taskDoc['assignedMembersID'],
        ownerID: taskDoc['ownerID'],
        isCompleted: taskDoc['isCompleted'],
      );
      this.taskTitle = this.task.title;
      this.isDecidedDueDate = this.task.isDecidedDueDate;
      this.dueDate = this.task.dueDate;
      this.assignedMembersID = this.task.assignedMembersID;
      this.isCompleted = this.task.isCompleted;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteTask() async {
    try {
      await groupDocRef.collection('tasks').doc(taskID).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
