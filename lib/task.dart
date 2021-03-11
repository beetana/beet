import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String ownerID;
  final String title;
  final String memo;
  final bool isDecidedDueDate;
  final DateTime dueDate;
  final List<dynamic> assignedMembersID;
  bool isCompleted;

  Task._(
    this.id,
    this.ownerID,
    this.title,
    this.memo,
    this.isDecidedDueDate,
    this.dueDate,
    this.assignedMembersID,
    this.isCompleted,
  );

  factory Task.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return Task._(
      doc.id,
      data['ownerID'],
      data['title'],
      data['memo'],
      data['isDecidedDueDate'],
      doc['isDecidedDueDate'] ? doc['dueDate'].toDate() : DateTime.now(),
      doc['assignedMembersID'],
      doc['isCompleted'],
    );
  }

  void toggleCheckState() {
    isCompleted = !isCompleted;
  }
}
