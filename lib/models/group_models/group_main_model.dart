import 'package:beet/objects/event.dart';
import 'package:beet/objects/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainModel extends ChangeNotifier {
  List<Event> events = [];
  int taskCount = 0;
  bool isLoading = false;
  DateTime currentDateTime = DateTime.now();
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
    taskCount = 0;
    startLoading();
    try {
      final taskQuery = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('tasks')
          .get();
      final tasks = taskQuery.docs.map((doc) => Task.doc(doc)).toList();
      tasks.forEach((task) {
        if (task.isCompleted == false) {
          taskCount += 1;
        }
      });
      await fetchEvents(groupId: groupId);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchEvents({String groupId}) async {
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    try {
      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('events')
          .where('end', isGreaterThan: currentTimestamp)
          .get();
      events = eventDoc.docs.map((doc) => Event.doc(doc)).toList();
      events.sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }
}
