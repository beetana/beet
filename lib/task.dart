import 'package:flutter/cupertino.dart';

class Task {
  final String ownerID;
  final String id;
  final String title;
  final String memo;
  final bool isDecidedDueDate;
  final DateTime dueDate;
  final List<dynamic> assignedMembersID;
  bool isCompleted;

  Task({
    this.ownerID,
    this.id,
    this.title,
    this.memo,
    this.isDecidedDueDate,
    this.dueDate,
    this.assignedMembersID,
    this.isCompleted,
  });

  void toggleCheckState() {
    isCompleted = !isCompleted;
  }
}
