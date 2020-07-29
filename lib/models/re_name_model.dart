import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReNameModel extends ChangeNotifier {
  String newName = '';

  Future reName() async {
    if (newName.isEmpty) {
      throw ('名前を入力してください');
    }
    try {
      await Firestore.instance.collection('users').add({
        'name': newName,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw ('変更できませんでした。やり直してください。');
    }
  }
}
