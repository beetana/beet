class Task {
  final String id;
  final String title;
  final bool isDecidedDueDate;
  final DateTime dueDate;
  final List<dynamic> assignedMembers;
  final String ownerID;
  bool isCompleted;

  Task(
      {this.id,
      this.title,
      this.isDecidedDueDate,
      this.dueDate,
      this.assignedMembers,
      this.ownerID,
      this.isCompleted});

  void toggleCheckState() {
    isCompleted = !isCompleted;
  }
}
