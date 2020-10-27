import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class GroupImageUpdateModel extends ChangeNotifier {
  String groupID;
  String groupImageURL;
  File imageFile;
  bool isLoading = false;

  void init({groupID, groupImageURL}) {
    this.groupID = groupID;
    this.groupImageURL = groupImageURL;
    print(this.groupImageURL);
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

  Future updateGroupImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }
    try {
      final storage = FirebaseStorage.instance;
      StorageTaskSnapshot snapshot = await storage
          .ref()
          .child("userImage/$groupID")
          .putFile(imageFile)
          .onComplete;
      final imageURL = await snapshot.ref.getDownloadURL();
      await Firestore.instance
          .collection('groups')
          .document(groupID)
          .updateData({'imageURL': imageURL});
      groupImageURL = imageURL;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw ('エラーが発生しました');
    }
  }
}
