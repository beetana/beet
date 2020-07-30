import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReNameModel extends ChangeNotifier {
  String newName = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future reName() async {
    if (newName.isEmpty) {
      throw ('名前を入力してください');
    }
    try {
      final user = await _auth.currentUser();
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData({
        'name': newName,
      });
    } catch (e) {
      throw ('変更できませんでした。やり直してください。');
    }
  }
}
