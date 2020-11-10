import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String imageURL;
  User._(
    this.id,
    this.name,
    this.imageURL,
  );
  factory User.doc(DocumentSnapshot doc) {
    final data = doc.data();
    return User._(
      doc.id,
      data['name'],
      data['imageURL'],
    );
  }
}
