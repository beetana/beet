import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileModel extends ChangeNotifier {
  String userID;
  String userName = '';
  String userImageURL = '';
  File imageFile;
  bool isLoading = false;
  List<String> joiningGroupsID = [];

  Future init({userID}) async {
    this.userID = userID;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    userName = userDoc['name'];
    userImageURL = userDoc['imageURL'];
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
    imageFile = null;
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }

    imageFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      maxWidth: 160,
      maxHeight: 160,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: CropStyle.circle,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'プロフィール画像',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'プロフィール画像',
        doneButtonTitle: '完了',
        cancelButtonTitle: 'キャンセル',
      ),
    );
    notifyListeners();
  }

  Future updateUserImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }
    try {
      final storage = FirebaseStorage.instance;
      TaskSnapshot snapshot =
          await storage.ref().child("userImage/$userID").putFile(imageFile);
      final String imageURL = await snapshot.ref.getDownloadURL();
      final joiningGroups = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      joiningGroupsID = (joiningGroups.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'imageURL': imageURL,
      });
      for (String groupID in joiningGroupsID) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupID)
            .collection('groupUsers')
            .doc(userID)
            .update({
          'imageURL': imageURL,
        });
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteUserImage() async {
    if (userImageURL.isEmpty) {
      throw ('プロフィール画像が設定されていません');
    }

    try {
      await FirebaseStorage.instance.ref().child("userImage/$userID").delete();
      final joiningGroups = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      joiningGroupsID = (joiningGroups.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'imageURL': '',
      });
      for (String groupID in joiningGroupsID) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupID)
            .collection('groupUsers')
            .doc(userID)
            .update({
          'imageURL': '',
        });
      }
      userImageURL = '';
      imageFile = null;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}