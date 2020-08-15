class Song {
  final String songID;
  final String title;
  final int playTime;
  bool checkboxState = false;

  Song({this.songID, this.title, this.playTime});

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
