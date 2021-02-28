import 'package:beet/event.dart';
import 'package:beet/content_owner_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserMainModel extends ChangeNotifier {
  DateTime currentDateTime = DateTime.now();
  List<Event> eventList = [];
  Map<String, ContentOwner> eventPlanner = {};
  bool isLoading = false;

  Future getEventList(userID) async {
    isLoading = true;
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    List<String> myIDList = [userID];

    try {
      QuerySnapshot joiningGroupDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      myIDList.addAll(joiningGroupDoc.docs.map((doc) => doc.id).toList());

      await fetchContentOwnerInfo(myIDList: myIDList);

      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collectionGroup('events')
          .where('myID', whereIn: myIDList)
          .where('end', isGreaterThan: currentTimestamp)
          .get();
      eventList = eventDoc.docs
          .map((doc) => Event(
                eventID: doc.id,
                myID: doc['myID'],
                eventTitle: doc['title'],
                eventPlace: doc['place'],
                eventMemo: doc['memo'],
                isAllDay: doc['isAllDay'],
                startingDateTime: doc['start'].toDate(),
                endingDateTime: doc['end'].toDate(),
                dateList: doc['dateList'].map((date) => date.toDate()).toList(),
              ))
          .toList();

      eventList
          .sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future fetchContentOwnerInfo({myIDList}) async {
    for (String id in myIDList) {
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
