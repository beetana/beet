import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTaskListModel extends ChangeNotifier {
  String userID = '';
  Map<String, User> joiningGroupUsers = {};
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  List<Task> notCompletedTasks = [];
  List<Task> changeStateTasks = [];
  bool isLoading = false;
  final firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String userID}) async {
    startLoading();
    final userDocRef = firestore.collection('users').doc(userID);
    this.userID = userID;
    try {
      DocumentSnapshot userDoc = await userDocRef.get();
      joiningGroupUsers[userID] = User.doc(userDoc);
      QuerySnapshot joiningGroupQuery =
          await userDocRef.collection('joiningGroup').get();
      final joiningGroups =
          joiningGroupQuery.docs.map((doc) => doc.id).toList();
      joiningGroups.forEach((groupID) async {
        QuerySnapshot groupUsers = await firestore
            .collection('groups')
            .doc(groupID)
            .collection('groupUsers')
            .get();
        final users = groupUsers.docs.map((doc) => User.doc(doc)).toList();
        users.forEach((user) {
          joiningGroupUsers[user.id] = user;
        });
      });
      await getTaskList(userID: userID);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getTaskList({String userID}) async {
    completedTasks = [];
    notCompletedTasks = [];
    changeStateTasks = [];
    try {
      QuerySnapshot taskQuery = await firestore
          .collectionGroup('tasks')
          .where('assignedMembersID', arrayContains: userID)
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
        final taskDocRef = task.ownerID == userID
            ? firestore
                .collection('users')
                .doc(userID)
                .collection('tasks')
                .doc(task.id)
            : firestore
                .collection('groups')
                .doc(task.ownerID)
                .collection('tasks')
                .doc(task.id);
        batch.update(taskDocRef, {
          'isCompleted': task.isCompleted,
        });
      });
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  void toggleCheckState(Task task) {
    task.toggleCheckState();
    changeStateTasks.contains(task)
        ? changeStateTasks.remove(task)
        : changeStateTasks.add(task);
    notifyListeners();
  }

  Future deleteTask({Task task}) async {
    final taskDocRef = task.ownerID == userID
        ? firestore
            .collection('users')
            .doc(userID)
            .collection('tasks')
            .doc(task.id)
        : firestore
            .collection('groups')
            .doc(task.ownerID)
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
