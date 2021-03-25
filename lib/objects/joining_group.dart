import 'package:cloud_firestore/cloud_firestore.dart';

class JoiningGroup {
  final String id;
  final String name;
  final String imageURL;
  final DateTime joinedAt;
  JoiningGroup._(
    this.id,
    this.name,
    this.imageURL,
    this.joinedAt,
  );
  factory JoiningGroup.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return JoiningGroup._(
      doc.id,
      data['name'],
      data['imageURL'],
      data['joinedAt'].toDate(),
    );
  }
}
