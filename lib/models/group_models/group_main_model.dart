import 'package:beet/objects/event.dart';
import 'package:beet/objects/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainModel extends ChangeNotifier {
  List<Event> events = [];
  int taskCount = 0;
  bool isLoading = false;
  DateTime currentDateTime;
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
    try {
      await fetchMainInfo(groupId: groupId);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchMainInfo({String groupId}) async {
    currentDateTime = DateTime.now();
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    try {
      final tasksQuery = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('tasks')
          .get();
      final tasks = tasksQuery.docs.map((doc) => Task.doc(doc)).toList();
      final notCompletedTasks =
          tasks.where((task) => task.isCompleted == false).toList();
      taskCount = notCompletedTasks.length;

      final eventsQuery = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('events')
          .where('end', isGreaterThan: currentTimestamp)
          .get();
      events = eventsQuery.docs.map((doc) => Event.doc(doc)).toList();
      events.sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }
}
