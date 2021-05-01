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
  bool isOwn;
  bool isLoading = false;
  ContentOwner owner;
  DocumentReference ownerDocRef;
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
    this.task = task;
    ownerId = task.ownerId;
    taskId = task.id;
    taskTitle = task.title;
    taskMemo = task.memo;
    isDecidedDueDate = task.isDecidedDueDate;
    dueDate = task.dueDate;
    assignedMembersId = task.assignedMembersId;
    isCompleted = task.isCompleted;
    isOwn = ownerId == userId;
    ownerDocRef = isOwn
        ? _firestore.collection('users').doc(userId)
        : _firestore.collection('groups').doc(ownerId);
    try {
      final DocumentSnapshot ownerDoc = await ownerDocRef.get();
      owner = ContentOwner.doc(ownerDoc);
      if (isOwn) {
        groupMembers[ownerId] = User.doc(ownerDoc);
      } else {
        final QuerySnapshot membersQuery =
            await ownerDocRef.collection('members').get();
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

  Future<void> fetchTask() async {
    try {
      final DocumentSnapshot taskDoc =
          await ownerDocRef.collection('tasks').doc(taskId).get();
      task = Task.doc(taskDoc);
      ownerId = task.ownerId;
      taskTitle = task.title;
      taskMemo = task.memo;
      isDecidedDueDate = task.isDecidedDueDate;
      dueDate = task.dueDate;
      assignedMembersId = task.assignedMembersId;
      isCompleted = task.isCompleted;
      isOwn = ownerId == userId;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future<void> deleteTask() async {
    try {
      await ownerDocRef.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
