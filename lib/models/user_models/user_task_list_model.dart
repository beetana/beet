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
  DocumentReference userDocRef;
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

  Future<void> init() async {
    startLoading();
    userDocRef = _firestore.collection('users').doc(userId);
    try {
      final DocumentSnapshot userDoc = await userDocRef.get();
      joiningGroupMembers[userId] = User.doc(userDoc);
      final QuerySnapshot joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();
      final List<String> joiningGroupsId =
          joiningGroupsQuery.docs.map((doc) => doc.id).toList();
      joiningGroupsId.forEach((groupId) async {
        final QuerySnapshot membersQuery = await _firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .get();
        final List<User> users =
            membersQuery.docs.map((doc) => User.doc(doc)).toList();
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

  Future<void> fetchTasks() async {
    completedTasks = [];
    notCompletedTasks = [];
    changeStateTasks = [];
    try {
      final QuerySnapshot tasksQuery = await _firestore
          .collectionGroup('tasks')
          .where('assignedMembersId', arrayContains: userId)
          .get();
      tasks = tasksQuery.docs.map((doc) => Task.doc(doc)).toList();
      tasks.forEach((task) {
        task.isCompleted
            ? completedTasks.add(task)
            : notCompletedTasks.add(task);
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
        final DocumentReference taskDocRef = task.ownerId == userId
            ? userDocRef.collection('tasks').doc(task.id)
            : _firestore
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

  Future<void> deleteTask({Task task}) async {
    final DocumentReference taskDocRef = task.ownerId == userId
        ? userDocRef.collection('tasks').doc(task.id)
        : _firestore
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
