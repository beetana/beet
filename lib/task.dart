class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final List<dynamic> assignedMembers;
  bool isCompleted;

  Task(
      {this.id,
      this.title,
      this.dueDate,
      this.assignedMembers,
      this.isCompleted});

  void toggleCheckState() {
    isCompleted = !isCompleted;
  }
}
