class Song {
  final String songID;
  final String title;
  final int playingTime;
  bool checkboxState = false;

  Song({this.songID, this.title, this.playingTime});

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
