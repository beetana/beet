class Song {
  final String title;
  final int playTime;
  bool checkboxState = false;

  Song({this.title, this.playTime});

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
