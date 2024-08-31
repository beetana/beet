import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTaskDetailsModel extends ChangeNotifier {
  late Task task;
  String ownerId = '';
  String taskId = '';
  String taskTitle = '';
  String taskMemo = '';
  late bool isDecidedDueDate;
  late DateTime dueDate;
  List<dynamic> assignedMembersId = [];
  Map<String, User> groupMembers = {};
  late bool isCompleted;
  late bool isOwn;
  bool isLoading = false;
  ContentOwner? owner;
  late DocumentReference ownerDocRef;
  final String userId = Auth.FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({required Task task}) async {
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
    ownerDocRef = isOwn ? _firestore.collection('users').doc(userId) : _firestore.collection('groups').doc(ownerId);

    try {
      final DocumentSnapshot ownerDoc = await ownerDocRef.get();
      print(ownerDoc);
      owner = ContentOwner.doc(ownerDoc as DocumentSnapshot<Map<String, dynamic>>);
      print(owner);
      if (isOwn) {
        print(isOwn);
        groupMembers[ownerId] = User.doc(ownerDoc as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        final QuerySnapshot membersQuery = await ownerDocRef.collection('members').get();
        final List<User> users = membersQuery.docs.map((doc) => User.doc(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
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
      final DocumentSnapshot taskDoc = await ownerDocRef.collection('tasks').doc(taskId).get();
      task = Task.doc(taskDoc as DocumentSnapshot<Map<String, dynamic>>);
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
