import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserMainModel extends ChangeNotifier {
  DateTime currentDateTime = DateTime.now();
  List<Event> eventList = [];
  List<String> joiningGroupList = [];
  bool isLoading = false;

  Future getEventList(userID) async {
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    isLoading = true;
    try {
      QuerySnapshot eventDoc = await Firestore.instance
          .collection('users')
          .document(userID)
          .collection('events')
          .where('end', isGreaterThan: currentTimestamp)
          .getDocuments();
      eventList = eventDoc.documents
          .map((doc) => Event(
                eventID: doc.documentID,
                eventTitle: doc['title'],
                eventPlace: doc['place'],
                eventMemo: doc['memo'],
                isAllDay: doc['isAllDay'],
                startingDateTime: doc['start'].toDate(),
                endingDateTime: doc['end'].toDate(),
                dateList: doc['dateList'].map((date) => date.toDate()).toList(),
              ))
          .toList();

      QuerySnapshot joiningGroupDoc = await Firestore.instance
          .collection('users')
          .document(userID)
          .collection('joiningGroup')
          .getDocuments();
      joiningGroupList =
          joiningGroupDoc.documents.map((e) => e.documentID).toList();
      print(joiningGroupList);
      //TODO whereIn句で10件までしかクエリできないので、参加できるグループを5つまでにするなどの対策が必要
      QuerySnapshot groupEventDoc = await Firestore.instance
          .collectionGroup('events')
          .where('groupID', whereIn: joiningGroupList)
          .where('end', isGreaterThan: currentTimestamp)
          .getDocuments();

      eventList.addAll(groupEventDoc.documents
          .map((doc) => Event(
                eventID: doc.documentID,
                eventTitle: doc['title'],
                eventPlace: doc['place'],
                eventMemo: doc['memo'],
                isAllDay: doc['isAllDay'],
                startingDateTime: doc['start'].toDate(),
                endingDateTime: doc['end'].toDate(),
                dateList: doc['dateList'].map((date) => date.toDate()).toList(),
              ))
          .toList());

      eventList
          .sort((a, b) => a.startingDateTime.compareTo(b.startingDateTime));
    } catch (e) {
      print(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
