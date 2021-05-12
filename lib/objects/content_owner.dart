import 'package:cloud_firestore/cloud_firestore.dart';

class ContentOwner {
  final String id;
  final String name;
  final String imageURL;

  ContentOwner._(
    this.id,
    this.name,
    this.imageURL,
  );

  factory ContentOwner.doc(DocumentSnapshot doc) {
    final data = doc.data();

    return ContentOwner._(
      doc.id,
      data['name'],
      data['imageURL'],
    );
  }
}
