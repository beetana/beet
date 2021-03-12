import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTaskDetailsModel extends ChangeNotifier {
  String userID = '';
  Task task;
  String ownerID = '';
  String taskID = '';
  String taskTitle = '';
  String taskMemo = '';
  bool isDecidedDueDate;
  DateTime dueDate;
  List<dynamic> assignedMembersID = [];
  Map<String, User> groupMembers = {};
  bool isCompleted;
  bool isLoading = false;
  ContentOwner owner;
  DocumentReference ownerDocRef;
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
    this.taskMemo = task.memo;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.dueDate = task.dueDate;
    this.assignedMembersID = task.assignedMembersID;
    this.isCompleted = task.isCompleted;
    this.ownerDocRef = ownerID == userID
        ? firestore.collection('users').doc(userID)
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

  Future getTask() async {
    try {
      DocumentSnapshot taskDoc =
          await ownerDocRef.collection('tasks').doc(taskID).get();
      this.task = Task.doc(taskDoc);
      this.ownerID = task.ownerID;
      this.taskTitle = task.title;
      this.taskMemo = task.memo;
      this.isDecidedDueDate = task.isDecidedDueDate;
      this.dueDate = task.dueDate;
      this.assignedMembersID = task.assignedMembersID;
      this.isCompleted = task.isCompleted;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future deleteTask() async {
    try {
      await ownerDocRef.collection('tasks').doc(taskID).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
