import 'package:beet/content_owner_info.dart';
import 'package:beet/task.dart';
import 'package:beet/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTaskDetailsModel extends ChangeNotifier {
  String userID = '';
  Task task;
  String ownerID = '';
  String taskID = '';
  String taskTitle = '';
  bool isDecidedDueDate;
  DateTime dueDate;
  List<dynamic> assignedMembersID = [];
  Map<String, User> groupMembers = {};
  bool isCompleted;
  bool isLoading = false;
  ContentOwner owner;
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String userID, Task task}) async {
    startLoading();
    this.userID = userID;
    this.task = task;
    this.ownerID = task.ownerID;
    this.taskID = task.id;
    this.taskTitle = task.title;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.dueDate = task.dueDate;
    this.assignedMembersID = task.assignedMembersID;
    this.isCompleted = task.isCompleted;
    final ownerDocRef = ownerID == userID
        ? firestore.collection('users').doc(ownerID)
        : firestore.collection('groups').doc(ownerID);
    try {
      final ownerDoc = await ownerDocRef.get();
      this.owner = ContentOwner.doc(ownerDoc);
      if (ownerID == userID) {
        groupMembers[ownerID] = User.doc(ownerDoc);
      } else {
        QuerySnapshot groupUsers =
            await ownerDocRef.collection('groupUsers').get();
        final users = groupUsers.docs.map((doc) => User.doc(doc)).toList();
        users.forEach((user) {
          groupMembers[user.id] = user;
        });
      }
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getTask({String userID, Task task}) async {
    final ownerID = task.ownerID;
    final taskDocRef = ownerID == userID
        ? firestore
            .collection('users')
            .doc(userID)
            .collection('tasks')
            .doc(task.id)
        : firestore
            .collection('groups')
            .doc(ownerID)
            .collection('tasks')
            .doc(task.id);
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
      this.ownerID = this.task.ownerID;
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
      final ownerDocRef = ownerID == userID
          ? firestore.collection('users').doc(ownerID)
          : firestore.collection('groups').doc(ownerID);
      await ownerDocRef.collection('tasks').doc(taskID).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
