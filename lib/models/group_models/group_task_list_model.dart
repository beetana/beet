import 'package:beet/objects/task.dart';
import 'package:beet/objects/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupTaskListModel extends ChangeNotifier {
  Map<String, User> members = {};
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  List<Task> notCompletedTasks = [];
  List<Task> changeStateTasks = [];
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

  Future init({String groupId}) async {
    startLoading();
    groupDocRef = firestore.collection('groups').doc(groupId);
    try {
      final membersQuery = await groupDocRef.collection('members').get();
      final users = membersQuery.docs.map((doc) => User.doc(doc)).toList();
      users.forEach((user) {
        members[user.id] = user;
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
      QuerySnapshot taskQuery = await groupDocRef.collection('tasks').get();
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
        final taskDocRef = groupDocRef.collection('tasks').doc(task.id);
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
    try {
      await groupDocRef.collection('tasks').doc(task.id).delete();
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
