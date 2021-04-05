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
  final picker = ImagePicker();
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

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
      DocumentSnapshot groupDoc =
          await firestore.collection('groups').doc(groupId).get();
      groupName = groupDoc['name'];
      groupImageURL = groupDoc['imageURL'];
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future pickImageFile() async {
    imageFile = null;
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      imageFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 160,
        maxHeight: 160,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'プロフィール画像',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'プロフィール画像',
          doneButtonTitle: '完了',
          cancelButtonTitle: 'キャンセル',
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future updateGroupImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }
    final batch = firestore.batch();
    final groupDocRef = firestore.collection('groups').doc(groupId);
    try {
      TaskSnapshot snapshot =
          await storage.ref().child("groupImage/$groupId").putFile(imageFile);
      groupImageURL = await snapshot.ref.getDownloadURL();
      batch.update(groupDocRef, {
        'imageURL': groupImageURL,
      });
      final groupUsersQuery = await groupDocRef.collection('groupUsers').get();
      groupUsersId = (groupUsersQuery.docs.map((doc) => doc.id).toList());
      for (String userId in groupUsersId) {
        final joiningGroupDocRef = firestore
            .collection('users')
            .doc(userId)
            .collection('joiningGroup')
            .doc(groupId);
        batch.update(joiningGroupDocRef, {
          'imageURL': groupImageURL,
        });
      }
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteGroupImage() async {
    if (groupImageURL.isEmpty) {
      throw ('プロフィール画像が設定されていません');
    }
    final batch = firestore.batch();
    final groupDocRef = firestore.collection('groups').doc(groupId);
    try {
      await storage.ref().child("groupImage/$groupId").delete();
      batch.update(groupDocRef, {
        'imageURL': '',
      });
      final groupUsersQuery = await groupDocRef.collection('groupUsers').get();
      groupUsersId = (groupUsersQuery.docs.map((doc) => doc.id).toList());
      for (String userId in groupUsersId) {
        final joiningGroupDocRef = firestore
            .collection('users')
            .doc(userId)
            .collection('joiningGroup')
            .doc(groupId);
        batch.update(joiningGroupDocRef, {
          'imageURL': '',
        });
      }
      await batch.commit();
      groupImageURL = '';
      imageFile = null;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
