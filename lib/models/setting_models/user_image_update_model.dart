import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserImageUpdateModel extends ChangeNotifier {
  String userID;
  String userImageURL;
  File imageFile;
  bool isLoading = false;

  void init({userID, userImageURL}) {
    this.userID = userID;
    this.userImageURL = userImageURL;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future pickImageFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  Future updateUserImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }
    try {
      final storage = FirebaseStorage.instance;
      StorageTaskSnapshot snapshot = await storage
          .ref()
          .child("userImage/$userID")
          .putFile(imageFile)
          .onComplete;
      final imageURL = await snapshot.ref.getDownloadURL();
      await Firestore.instance
          .collection('users')
          .document(userID)
          .updateData({'imageURL': imageURL});
      userImageURL = imageURL;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
