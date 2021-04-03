import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserTaskDetailsModel extends ChangeNotifier {
  Task task;
  String ownerId = '';
  String taskId = '';
  String taskTitle = '';
  String taskMemo = '';
  bool isDecidedDueDate;
  DateTime dueDate;
  List<dynamic> assignedMembersId = [];
  Map<String, User> groupMembers = {};
  bool isCompleted;
  bool isLoading = false;
  ContentOwner owner;
  DocumentReference ownerDocRef;
  final firestore = FirebaseFirestore.instance;
  final String userId = Auth.FirebaseAuth.instance.currentUser.uid;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({Task task}) async {
    startLoading();
    this.task = task;
    this.ownerId = task.ownerId;
    this.taskId = task.id;
    this.taskTitle = task.title;
    this.taskMemo = task.memo;
    this.isDecidedDueDate = task.isDecidedDueDate;
    this.dueDate = task.dueDate;
    this.assignedMembersId = task.assignedMembersId;
    this.isCompleted = task.isCompleted;
    this.ownerDocRef = ownerId == userId
        ? firestore.collection('users').doc(userId)
        : firestore.collection('groups').doc(ownerId);
    try {
      final ownerDoc = await ownerDocRef.get();
      this.owner = ContentOwner.doc(ownerDoc);
      if (ownerId == userId) {
        groupMembers[ownerId] = User.doc(ownerDoc);
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
          await ownerDocRef.collection('tasks').doc(taskId).get();
      this.task = Task.doc(taskDoc);
      this.ownerId = task.ownerId;
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
      await ownerDocRef.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
