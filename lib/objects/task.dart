import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String ownerId;
  final String title;
  final String memo;
  final bool isDecidedDueDate;
  final DateTime dueDate;
  final List<dynamic> assignedMembersId;
  bool isCompleted;

  Task._(
    this.id,
    this.ownerId,
    this.title,
    this.memo,
    this.isDecidedDueDate,
    this.dueDate,
    this.assignedMembersId,
    this.isCompleted,
  );

  factory Task.doc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return Task._(
      doc.id,
      data?['ownerId'],
      data?['title'],
      data?['memo'],
      data?['isDecidedDueDate'],
      doc['isDecidedDueDate'] ? doc['dueDate'].toDate() : DateTime.now(),
      doc['assignedMembersId'],
      doc['isCompleted'],
    );
  }

  void toggleCheckState() {
    isCompleted = !isCompleted;
  }
}
