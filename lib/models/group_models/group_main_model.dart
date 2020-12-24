import 'package:beet/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainModel extends ChangeNotifier {
  DateTime currentDateTime = DateTime.now();
  List<Event> eventList = [];
  bool isLoading = false;
  String invitedGroupID;
  String invitedGroupName;

  Future getEventList(groupID) async {
    final currentTimestamp = Timestamp.fromDate(currentDateTime);
    isLoading = true;
    try {
      QuerySnapshot eventDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('events')
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

//  void fetchLinkData() async {
//    try {
//      PendingDynamicLinkData link =
//          await FirebaseDynamicLinks.instance.getInitialLink();
//      handleLinkData(link);
//      print('いえい');
//      print('complete getInitialLink');
//
//      FirebaseDynamicLinks.instance.onLink(
//          onSuccess: (PendingDynamicLinkData dynamicLink) async {
//        handleLinkData(dynamicLink);
//        print('complete onLink');
//      });
//    } catch (e) {
//      print(e.toString());
//    }
//  }
//
//  void handleLinkData(PendingDynamicLinkData data) {
//    final Uri deepLink = data?.link;
//    if (deepLink != null) {
//      final queryParams = deepLink.queryParameters;
//      invitedGroupID = queryParams['id'];
//      invitedGroupName = queryParams['name'];
//      print('わーお');
//      print(queryParams);
//      print('招待されたグループのIDは$invitedGroupID');
//      print('招待されたグループの名前は$invitedGroupName');
//      notifyListeners();
//      main(invitedGroupID: invitedGroupID, invitedGroupName: invitedGroupName);
//    }
//  }
}
