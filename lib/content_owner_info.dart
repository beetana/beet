import 'package:cloud_firestore/cloud_firestore.dart';

class ContentOwnerInfo {
  final String name;
  final String imageURL;

  ContentOwnerInfo._(
    this.name,
    this.imageURL,
  );

  factory ContentOwnerInfo.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return ContentOwnerInfo._(
      data['name'],
      data['imageURL'],
    );
  }
}
