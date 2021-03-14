import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String ownerId;
  final String title;
  final String place;
  final String memo;
  final bool isAllDay;
  DateTime startingDateTime;
  DateTime endingDateTime;
  final List<dynamic> dateList;

  Event._(
    this.id,
    this.ownerId,
    this.title,
    this.place,
    this.memo,
    this.isAllDay,
    this.startingDateTime,
    this.endingDateTime,
    this.dateList,
  );

  factory Event.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return Event._(
      doc.id,
      data['ownerId'],
      data['title'],
      data['place'],
      data['memo'],
      data['isAllDay'],
      data['start'].toDate(),
      data['end'].toDate(),
      data['dateList'].map((date) => date.toDate()).toList(),
    );
  }
}
