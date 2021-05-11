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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({String groupId}) async {
    startLoading();
    groupDocRef = _firestore.collection('groups').doc(groupId);

    try {
      final QuerySnapshot membersQuery =
          await groupDocRef.collection('members').get();
      final List<User> users =
          membersQuery.docs.map((doc) => User.doc(doc)).toList();
      users.forEach((user) {
        members[user.id] = user;
      });
      await fetchTasks();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future<void> fetchTasks() async {
    completedTasks = [];
    notCompletedTasks = [];
    changeStateTasks = [];

    try {
      final QuerySnapshot tasksQuery = await groupDocRef.collection('tasks').get();
      tasks = tasksQuery.docs.map((doc) => Task.doc(doc)).toList();
      tasks.forEach((task) {
        task.isCompleted ? completedTasks.add(task) : notCompletedTasks.add(task);
      });
      completedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      notCompletedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future<void> updateCheckState() async {
    try {
      final WriteBatch batch = _firestore.batch();

      changeStateTasks.forEach((task) {
        final DocumentReference taskDocRef =
            groupDocRef.collection('tasks').doc(task.id);
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

  Future<void> deleteTask({Task task}) async {
    try {
      await groupDocRef.collection('tasks').doc(task.id).delete();
      tasks.remove(task);
      completedTasks.contains(task)
          ? completedTasks.remove(task)
          : notCompletedTasks.remove(task);
      if (changeStateTasks.contains(task)) {
        changeStateTasks.remove(task);
      }
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
}
