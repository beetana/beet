import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InquiryModel extends ChangeNotifier {
  String inquiryContent = '';
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future submitInquiry() async {
    if (inquiryContent.isEmpty) {
      throw ('お問い合わせ内容を入力してください');
    }
    try {
      await FirebaseFirestore.instance.collection('inquiries').add({
        'userId': FirebaseAuth.instance.currentUser.uid,
        'content': inquiryContent,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
