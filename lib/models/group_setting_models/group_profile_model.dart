import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GroupProfileModel extends ChangeNotifier {
  String groupId = '';
  String groupName = '';
  String groupImageURL = '';
  File? imageFile;
  bool isLoading = false;
  List<String> membersId = [];
  late DocumentReference groupDocRef;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init({required String groupId}) async {
    startLoading();
    this.groupId = groupId;
    groupDocRef = _firestore.collection('groups').doc(groupId);
    try {
      final DocumentSnapshot groupDoc = await groupDocRef.get();
      groupName = groupDoc['name'];
      groupImageURL = groupDoc['imageURL'];
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future<void> pickImageFile() async {
    imageFile = null;

    try {
      // 端末のギャラリーから画像を取得
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      // 取得した画像を1:1でトリミングし、アップロードするimageFileに代入
      // 細かい設定値は必要に応じて変更可
      final croppedFile = (await ImageCropper().cropImage(
        sourcePath: pickedFile!.path,
        maxWidth: 160,
        maxHeight: 160,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'プロフィール画像',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(
            title: 'プロフィール画像',
            doneButtonTitle: '完了',
            cancelButtonTitle: 'キャンセル',
            aspectRatioPresets: [CropAspectRatioPreset.square],
            cropStyle: CropStyle.circle,
          ),
        ],
      ));
      imageFile = File(croppedFile!.path);
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> updateGroupImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }

    final WriteBatch batch = _firestore.batch();

    try {
      final TaskSnapshot snapshot = await _storage.ref().child("groupImage/$groupId").putFile(
            imageFile!,
            SettableMetadata(contentType: 'image/jpeg'),
          );
      groupImageURL = await snapshot.ref.getDownloadURL();
      batch.update(groupDocRef, {
        'imageURL': groupImageURL,
      });
      final QuerySnapshot membersQuery = await groupDocRef.collection('members').get();
      membersId = (membersQuery.docs.map((doc) => doc.id).toList());
      for (String userId in membersId) {
        final DocumentReference joiningGroupDocRef = _firestore.collection('users').doc(userId).collection('joiningGroups').doc(groupId);
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

  Future<void> deleteGroupImage() async {
    if (groupImageURL.isEmpty) {
      throw ('プロフィール画像が設定されていません');
    }

    final WriteBatch batch = _firestore.batch();

    try {
      await _storage.ref().child("groupImage/$groupId").delete();
      batch.update(groupDocRef, {
        'imageURL': '',
      });
      final QuerySnapshot membersQuery = await groupDocRef.collection('members').get();
      membersId = (membersQuery.docs.map((doc) => doc.id).toList());
      for (String userId in membersId) {
        final DocumentReference joiningGroupDocRef = _firestore.collection('users').doc(userId).collection('joiningGroups').doc(groupId);
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
