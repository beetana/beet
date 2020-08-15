class Song {
  final String id;
  final String title;
  final int playTime;
  bool checkboxState = false;

  Song({this.id, this.title, this.playTime});

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
