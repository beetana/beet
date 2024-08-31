import 'package:beet/objects/set_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Song implements SetList {
  final String id;
  @override
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

  factory Song.doc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return Song._(
      doc.id,
      data?['title'],
      data?['memo'],
      data?['minute'],
    );
  }

  void toggleCheckBoxState() {
    checkboxState = !checkboxState;
  }
}
