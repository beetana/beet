class Song {
  final String id;
  final String title;
  final String memo;
  final int playingTime;
  bool checkboxState = false;

  Song({this.id, this.title, this.memo, this.playingTime});

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
