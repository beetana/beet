import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMember {
  final String id;
  final String name;
  final String imageURL;
  final DateTime joinedAt;
  GroupMember._(
    this.id,
    this.name,
    this.imageURL,
    this.joinedAt,
  );
  factory GroupMember.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return GroupMember._(
      doc.id,
      data['name'],
      data['imageURL'],
      data['joinedAt'].toDate(),
    );
  }
}
