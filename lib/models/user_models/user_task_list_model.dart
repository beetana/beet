import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserTaskListModel extends ChangeNotifier {
  Map<String, User> joiningGroupMembers = {};
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  List<Task> notCompletedTasks = [];
  List<Task> changeStateTasks = [];
  bool isLoading = false;
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

  Future init() async {
    startLoading();
    final userDocRef = firestore.collection('users').doc(userId);
    try {
      DocumentSnapshot userDoc = await userDocRef.get();
      joiningGroupMembers[userId] = User.doc(userDoc);
      final joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();
      final joiningGroupsId =
          joiningGroupsQuery.docs.map((doc) => doc.id).toList();
      joiningGroupsId.forEach((groupId) async {
        final membersQuery = await firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .get();
        final users = membersQuery.docs.map((doc) => User.doc(doc)).toList();
        users.forEach((user) {
          joiningGroupMembers[user.id] = user;
        });
      });
      await fetchTasks();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchTasks() async {
    completedTasks = [];
    notCompletedTasks = [];
    changeStateTasks = [];
    try {
      QuerySnapshot taskQuery = await firestore
          .collectionGroup('tasks')
          .where('assignedMembersId', arrayContains: userId)
          .get();
      tasks = taskQuery.docs.map((doc) => Task.doc(doc)).toList();
      tasks.forEach((task) {
        task.isCompleted
            ? completedTasks.add(task)
            : notCompletedTasks.add(task);
      });
      completedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      notCompletedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future updateCheckState() async {
    try {
      final batch = firestore.batch();
      changeStateTasks.forEach((task) {
        final taskDocRef = task.ownerId == userId
            ? firestore
                .collection('users')
                .doc(userId)
                .collection('tasks')
                .doc(task.id)
            : firestore
                .collection('groups')
                .doc(task.ownerId)
                .collection('tasks')
                .doc(task.id);
        batch.update(taskDocRef, {
          'isCompleted': task.isCompleted,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  void toggleCheckState({Task task}) {
    task.toggleCheckState();
    changeStateTasks.contains(task)
        ? changeStateTasks.remove(task)
        : changeStateTasks.add(task);
    notifyListeners();
  }

  Future deleteTask({Task task}) async {
    final taskDocRef = task.ownerId == userId
        ? firestore
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .doc(task.id)
        : firestore
            .collection('groups')
            .doc(task.ownerId)
            .collection('tasks')
            .doc(task.id);
    try {
      await taskDocRef.delete();
      tasks.remove(task);
      completedTasks.remove(task);
      notCompletedTasks.remove(task);
      changeStateTasks.remove(task);
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
