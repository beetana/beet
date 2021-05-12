import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InquiryModel extends ChangeNotifier {
  String inquiryContent = '';
  bool isLoading = false;
  final String userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> submitInquiry() async {
    if (inquiryContent.isEmpty) {
      throw ('お問い合わせ内容を入力してください');
    }

    try {
      await _firestore.collection('inquiries').add({
        'userId': userId,
        'content': inquiryContent,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
