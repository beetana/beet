class Song {
  final String id;
  final String title;
  final int playingTime;
  bool checkboxState = false;

  Song({this.id, this.title, this.playingTime});

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
