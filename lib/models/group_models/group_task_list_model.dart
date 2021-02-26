import 'package:beet/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupTaskListModel extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  String groupID = '';
  Map<String, String> memberImages = {};
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  List<Task> notCompletedTasks = [];
  List<Task> changeStateTasks = [];
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String groupID}) async {
    startLoading();
    this.groupID = groupID;
    try {
      QuerySnapshot groupUsers = await firestore
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .get();
      groupUsers.docs.map((doc) => memberImages[doc.id] = doc['imageURL']);
      final userIDs = (groupUsers.docs.map((doc) => doc.id).toList());
      final userImageURLs =
          (groupUsers.docs.map((doc) => doc['imageURL']).toList());
      for (int i = 0; i < userIDs.length; i++) {
        memberImages[userIDs[i]] = userImageURLs[i];
      }
      getTaskList(groupID: groupID);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getTaskList({String groupID}) async {
    completedTasks = [];
    notCompletedTasks = [];
    changeStateTasks = [];
    try {
      QuerySnapshot taskDoc = await firestore
          .collection('groups')
          .doc(groupID)
          .collection('tasks')
          .get();
      tasks = taskDoc.docs
          .map((doc) => Task(
                id: doc.id,
                title: doc['title'],
                isDecidedDueDate: doc['isDecidedDueDate'],
                dueDate: doc['isDecidedDueDate']
                    ? doc['dueDate'].toDate()
                    : DateTime.now(),
                assignedMembers: doc['assignedMembers'],
                isCompleted: doc['isCompleted'],
              ))
          .toList();
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
        final taskDocRef = firestore
            .collection('groups')
            .doc(groupID)
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
}
