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
    ownerId = task.ownerId;
    taskId = task.id;
    taskTitle = task.title;
    taskMemo = task.memo;
    isDecidedDueDate = task.isDecidedDueDate;
    dueDate = task.dueDate;
    assignedMembersId = task.assignedMembersId;
    isCompleted = task.isCompleted;
    ownerDocRef = ownerId == userId
        ? firestore.collection('users').doc(userId)
        : firestore.collection('groups').doc(ownerId);
    try {
      final ownerDoc = await ownerDocRef.get();
      owner = ContentOwner.doc(ownerDoc);
      if (ownerId == userId) {
        groupMembers[ownerId] = User.doc(ownerDoc);
      } else {
        final membersQuery = await ownerDocRef.collection('members').get();
        final users = membersQuery.docs.map((doc) => User.doc(doc)).toList();
        users.forEach((user) {
          groupMembers[user.id] = user;
        });
      }
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchTask() async {
    try {
      final taskDoc = await ownerDocRef.collection('tasks').doc(taskId).get();
      task = Task.doc(taskDoc);
      ownerId = task.ownerId;
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

  Future deleteTask() async {
    try {
      await ownerDocRef.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
