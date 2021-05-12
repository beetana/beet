import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String memo;
  final int playingTime;
  bool checkboxState = false;

  Song._(
    this.id,
    this.title,
    this.memo,
    this.playingTime,
  );

  factory Song.doc(DocumentSnapshot doc) {
    final data = doc.data();

    return Song._(
      doc.id,
      data['title'],
      data['memo'],
      data['minute'],
    );
  }

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
