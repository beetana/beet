import 'package:cloud_firestore/cloud_firestore.dart';

class EventPlannerInfo {
  final String name;
  final String imageURL;

  EventPlannerInfo._(
    this.name,
    this.imageURL,
  );

  factory EventPlannerInfo.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return EventPlannerInfo._(
      data['name'],
      data['imageURL'],
    );
  }
}
