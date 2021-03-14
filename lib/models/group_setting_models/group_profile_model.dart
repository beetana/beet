import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GroupProfileModel extends ChangeNotifier {
  String groupId;
  String groupName = '';
  String groupImageURL = '';
  File imageFile;
  bool isLoading = false;
  List<String> groupUsersId = [];

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init({String groupId}) async {
    startLoading();
    this.groupId = groupId;
    try {
      DocumentSnapshot groupDoc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();
      groupName = groupDoc['name'];
      groupImageURL = groupDoc['imageURL'];
    } catch (e) {
      print(e);
    }
    endLoading();
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

  Future updateGroupImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }
    try {
      final storage = FirebaseStorage.instance;
      TaskSnapshot snapshot =
          await storage.ref().child("groupImage/$groupId").putFile(imageFile);
      final String imageURL = await snapshot.ref.getDownloadURL();
      final groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .get();
      groupUsersId = (groupUsers.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        'imageURL': imageURL,
      });
      for (String userId in groupUsersId) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('joiningGroup')
            .doc(groupId)
            .update({
          'imageURL': imageURL,
        });
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteGroupImage() async {
    if (groupImageURL.isEmpty) {
      throw ('プロフィール画像が設定されていません');
    }

    try {
      await FirebaseStorage.instance
          .ref()
          .child("groupImage/$groupId")
          .delete();
      final groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('groupUsers')
          .get();
      groupUsersId = (groupUsers.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        'imageURL': '',
      });
      for (String userId in groupUsersId) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('joiningGroup')
            .doc(groupId)
            .update({
          'imageURL': '',
        });
      }
      groupImageURL = '';
      imageFile = null;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
