import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReNameModel extends ChangeNotifier {
  String newName = '';
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

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
      print(e);
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'Error 5':
      return '変更先のデータが見つかりませんでした';
    default:
      return '不明なエラーです';
  }
}
