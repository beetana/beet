import 'package:beet/objects/event.dart';
import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserMainModel extends ChangeNotifier {
  List<Event> events = [];
  Map<String, ContentOwner> eventOwners = {};
  int taskCount = 0;
  bool isLoading = false;
  DateTime currentDateTime;
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
    try {
      await fetchMainInfo();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchMainInfo() async {
    currentDateTime = DateTime.now();
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    List<String> ownerIdList = [userId];
    try {
      final tasksQuery = await firestore
          .collectionGroup('tasks')
          .where('assignedMembersId', arrayContains: userId)
          .get();
      final tasks = tasksQuery.docs.map((doc) => Task.doc(doc)).toList();
      final notCompletedTasks =
          tasks.where((task) => task.isCompleted == false).toList();
      taskCount = notCompletedTasks.length;

      final joiningGroupsQuery = await firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroups')
          .get();
      ownerIdList.addAll(joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      await fetchContentOwnerInfo(ownerIdList: ownerIdList);

      final eventsQuery = await firestore
          .collectionGroup('events')
          .where('ownerId', whereIn: ownerIdList)
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

  Future fetchContentOwnerInfo({List<String> ownerIdList}) async {
    for (String id in ownerIdList) {
      if (id.length == 28) {
        final userDoc = await firestore.collection('users').doc(id).get();
        ContentOwner owner = ContentOwner.doc(userDoc);
        eventOwners[id] = owner;
      } else {
        final groupDoc = await firestore.collection('groups').doc(id).get();
        ContentOwner owner = ContentOwner.doc(groupDoc);
        eventOwners[id] = owner;
      }
    }
  }
}
