import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserMainModel extends ChangeNotifier {
  DateTime currentDateTime = DateTime.now();
  List<Event> eventList = [];
  List<String> myIDList = [];
  bool isLoading = false;

  Future getEventList(userID) async {
    isLoading = true;
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    myIDList = [userID];
    try {
      QuerySnapshot joiningGroupDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      myIDList.addAll(joiningGroupDoc.docs.map((doc) => doc.id).toList());

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
      print(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
