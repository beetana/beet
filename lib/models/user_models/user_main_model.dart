import 'package:beet/objects/event.dart';
import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserMainModel extends ChangeNotifier {
  List<Event> events = [];
  Map<String, ContentOwner> eventPlanner = {};
  int taskCount = 0;
  bool isLoading = false;
  DateTime currentDateTime = DateTime.now();
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
    taskCount = 0;
    startLoading();
    try {
      final taskQuery = await firestore
          .collectionGroup('tasks')
          .where('assignedMembersId', arrayContains: userId)
          .get();
      final tasks = taskQuery.docs.map((doc) => Task.doc(doc)).toList();
      tasks.forEach((task) {
        if (task.isCompleted == false) {
          taskCount += 1;
        }
      });
      await fetchEvents();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchEvents() async {
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    List<String> ownerIdList = [userId];
    try {
      QuerySnapshot joiningGroupQuery = await firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroup')
          .get();
      ownerIdList.addAll(joiningGroupQuery.docs.map((doc) => doc.id).toList());

      await fetchContentOwnerInfo(ownerIdList: ownerIdList);

      QuerySnapshot eventQuery = await firestore
          .collectionGroup('events')
          .where('ownerId', whereIn: ownerIdList)
          .where('end', isGreaterThan: currentTimestamp)
          .get();
      events = eventQuery.docs.map((doc) => Event.doc(doc)).toList();

      events.sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future fetchContentOwnerInfo({List<String> ownerIdList}) async {
    for (String id in ownerIdList) {
      if (id.length == 28) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(id).get();
        ContentOwner info = ContentOwner.doc(userDoc);
        eventPlanner[id] = info;
      } else {
        DocumentSnapshot groupDoc =
            await firestore.collection('groups').doc(id).get();
        ContentOwner info = ContentOwner.doc(groupDoc);
        eventPlanner[id] = info;
      }
    }
  }
}
