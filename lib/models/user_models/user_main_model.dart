import 'package:beet/objects/content_owner.dart';
import 'package:beet/objects/event.dart';
import 'package:beet/objects/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';

class UserMainModel extends ChangeNotifier {
  List<Event> events = [];
  Map<String, ContentOwner> eventOwners = {};
  int notCompletedTasksCount = 0;
  bool isLoading = false;
  late DateTime currentDateTime;
  final String userId = Auth.FirebaseAuth.instance.currentUser!.uid;
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
    try {
      await fetchMainInfo();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future<void> fetchMainInfo() async {
    currentDateTime = DateTime.now();
    final Timestamp currentTimestamp = Timestamp.fromDate(currentDateTime);
    List<String> ownerIdList = [userId];

    try {
      final QuerySnapshot tasksQuery = await _firestore
          .collectionGroup('tasks')
          .where('assignedMembersId', arrayContains: userId)
          .get();
      final List<Task> tasks = tasksQuery.docs
          .map((doc) => Task.doc(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
      final List<Task> notCompletedTasks =
          tasks.where((task) => !task.isCompleted).toList();
      notCompletedTasksCount = notCompletedTasks.length;

      final QuerySnapshot joiningGroupsQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroups')
          .get();
      ownerIdList.addAll(joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      await fetchContentOwnerInfo(ownerIdList: ownerIdList);

      final QuerySnapshot eventsQuery = await _firestore
          .collectionGroup('events')
          .where('ownerId', whereIn: ownerIdList)
          .where('end', isGreaterThan: currentTimestamp)
          .get();
      events = eventsQuery.docs
          .map((doc) => Event.doc(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
      events.sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    notifyListeners();
  }

  Future<void> fetchContentOwnerInfo({required List<String> ownerIdList}) async {
    for (String id in ownerIdList) {
      // FirebaseAuthのId(28桁)をそのままユーザーのIdとしているので桁数で判別できる
      if (id.length == 28) {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(id).get();
        final ContentOwner owner =
            ContentOwner.doc(userDoc as DocumentSnapshot<Map<String, dynamic>>);
        eventOwners[id] = owner;
      } else {
        final DocumentSnapshot groupDoc =
            await _firestore.collection('groups').doc(id).get();
        final ContentOwner owner =
            ContentOwner.doc(groupDoc as DocumentSnapshot<Map<String, dynamic>>);
        eventOwners[id] = owner;
      }
    }
  }
}
