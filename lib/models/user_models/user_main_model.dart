import 'package:beet/event.dart';
import 'package:beet/content_owner_info.dart';
import 'package:beet/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserMainModel extends ChangeNotifier {
  List<Event> eventList = [];
  Map<String, ContentOwner> eventPlanner = {};
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

  Future init({String userID}) async {
    taskCount = 0;
    startLoading();
    try {
      final taskQuery = await firestore
          .collectionGroup('tasks')
          .where('assignedMembersID', arrayContains: userID)
          .get();
      final tasks = taskQuery.docs
          .map((doc) => Task(
                id: doc.id,
                title: doc['title'],
                memo: doc['memo'],
                isDecidedDueDate: doc['isDecidedDueDate'],
                dueDate: doc['isDecidedDueDate']
                    ? doc['dueDate'].toDate()
                    : DateTime.now(),
                assignedMembersID: doc['assignedMembersID'],
                ownerID: doc['ownerID'],
                isCompleted: doc['isCompleted'],
              ))
          .toList();
      tasks.forEach((task) {
        if (task.isCompleted == false) {
          taskCount += 1;
        }
      });
      await getEventList(userID: userID);
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future getEventList({String userID}) async {
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    List<String> ownerIDList = [userID];
    try {
      QuerySnapshot joiningGroupDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      ownerIDList.addAll(joiningGroupDoc.docs.map((doc) => doc.id).toList());

      await fetchContentOwnerInfo(ownerIDList: ownerIDList);

      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collectionGroup('events')
          .where('ownerID', whereIn: ownerIDList)
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

  Future fetchContentOwnerInfo({ownerIDList}) async {
    for (String id in ownerIDList) {
      if (id.length == 28) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(id).get();
        ContentOwner info = ContentOwner.doc(userDoc);
        eventPlanner[id] = info;
      } else {
        DocumentSnapshot groupDoc =
            await FirebaseFirestore.instance.collection('groups').doc(id).get();
        ContentOwner info = ContentOwner.doc(groupDoc);
        eventPlanner[id] = info;
      }
    }
  }
}
