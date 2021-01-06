import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GroupUpdateModel extends ChangeNotifier {
  String groupID;
  String groupName = '';
  String groupImageURL;
  File imageFile;
  bool isLoading = false;
  List<String> groupUsersID = [];

  void init({groupID, groupName, groupImageURL}) {
    this.groupID = groupID;
    this.groupName = groupName;
    this.groupImageURL = groupImageURL;
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

  Future updateGroupName() async {
    if (groupName.isEmpty) {
      throw ('グループ名を入力してください');
    }
    try {
      final groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .get();
      groupUsersID = (groupUsers.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .update({
        'name': groupName,
      });
      for (String userID in groupUsersID) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('joiningGroup')
            .doc(groupID)
            .update({
          'name': groupName,
        });
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future pickImageFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
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
          await storage.ref().child("groupImage/$groupID").putFile(imageFile);
      final String imageURL = await snapshot.ref.getDownloadURL();
      final groupUsers = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .collection('groupUsers')
          .get();
      groupUsersID = (groupUsers.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupID)
          .update({'imageURL': imageURL});
      for (String userID in groupUsersID) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('joiningGroup')
            .doc(groupID)
            .update({
          'imageURL': imageURL,
        });
      }
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
