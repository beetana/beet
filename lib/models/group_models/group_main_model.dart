import 'package:beet/event.dart';
import 'package:beet/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainModel extends ChangeNotifier {
  List<Event> eventList = [];
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

  Future init({String groupID}) async {
    taskCount = 0;
    startLoading();
    try {
      final taskQuery = await firestore
          .collection('groups')
          .doc(groupID)
          .collection('tasks')
          .get();
      final tasks = taskQuery.docs.map((doc) => Task.doc(doc)).toList();
      tasks.forEach((task) {
        if (task.isCompleted == false) {
          taskCount += 1;
        }
      });
      await getEventList(groupID: groupID);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getEventList({String groupID}) async {
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    try {
      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('events')
          .where('end', isGreaterThan: currentTimestamp)
          .get();
      eventList = eventDoc.docs.map((doc) => Event.doc(doc)).toList();
      eventList
          .sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
