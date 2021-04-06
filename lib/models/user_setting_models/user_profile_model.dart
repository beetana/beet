import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserProfileModel extends ChangeNotifier {
  String userName = '';
  String userImageURL = '';
  File imageFile;
  bool isLoading = false;
  List<String> joiningGroupsId = [];
  final String userId = Auth.FirebaseAuth.instance.currentUser.uid;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init() async {
    startLoading();
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      userName = userDoc['name'];
      userImageURL = userDoc['imageURL'];
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future pickImageFile() async {
    imageFile = null;
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
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

  Future updateUserImage() async {
    if (imageFile == null) {
      throw ('ファイルが選択されていません');
    }
    final batch = firestore.batch();
    final userDocRef = firestore.collection('users').doc(userId);
    try {
      TaskSnapshot snapshot =
          await storage.ref().child("userImage/$userId").putFile(imageFile);
      userImageURL = await snapshot.ref.getDownloadURL();
      batch.update(userDocRef, {
        'imageURL': userImageURL,
      });
      final joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();
      joiningGroupsId = (joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      for (String groupId in joiningGroupsId) {
        final memberDocRef = firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc(userId);
        batch.update(memberDocRef, {
          'imageURL': userImageURL,
        });
      }
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteUserImage() async {
    if (userImageURL.isEmpty) {
      throw ('プロフィール画像が設定されていません');
    }
    final batch = firestore.batch();
    final userDocRef = firestore.collection('users').doc(userId);
    try {
      await storage.ref().child("userImage/$userId").delete();
      batch.update(userDocRef, {
        'imageURL': '',
      });
      final joiningGroupsQuery = await firestore
          .collection('users')
          .doc(userId)
          .collection('joiningGroups')
          .get();
      joiningGroupsId = (joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      for (String groupId in joiningGroupsId) {
        final memberDocRef = firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc(userId);
        batch.update(memberDocRef, {
          'imageURL': '',
        });
      }
      await batch.commit();
      userImageURL = '';
      imageFile = null;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteAccount({String password}) async {
    final Auth.User firebaseUser = Auth.FirebaseAuth.instance.currentUser;
    final userDocRef = firestore.collection('users').doc(userId);
    final batch = firestore.batch();
    try {
      await firebaseUser
          .reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
        email: firebaseUser.email,
        password: password,
      ));
      // Firebase Storageにあるプロフィール画像を削除
      if (userImageURL.isNotEmpty) {
        await storage.ref().child("userImage/$userId").delete();
      }
      // 参加しているグループから自分のドキュメントを削除
      final joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();
      joiningGroupsId = (joiningGroupsQuery.docs.map((doc) => doc.id).toList());
      if (joiningGroupsId.isNotEmpty) {
        for (String groupId in joiningGroupsId) {
          final groupDocRef = firestore.collection('groups').doc(groupId);
          final memberDocRef = firestore
              .collection('groups')
              .doc(groupId)
              .collection('members')
              .doc(userId);
          final membersQuery = await groupDocRef.collection('members').get();
          membersQuery.size == 1
              // もしグループに自分1人しかいなければグループのドキュメントごと削除する
              // グループのドキュメントを削除するとCloud FunctionsのdeleteGroupがトリガーされ、
              // そのグループのサブコレクションも削除される
              ? batch.delete(groupDocRef)
              : batch.delete(memberDocRef);
        }
      }
      // ユーザーのドキュメントを削除するとCloud FunctionsのdeleteUserがトリガーされ、
      // userDocRef以下のサブコレクションも削除される
      batch.delete(userDocRef);
      await batch.commit();
      // ユーザーの認証情報を削除
      await firebaseUser.delete();
    } catch (e) {
      print(e.code);
      throw (_convertErrorMessage(e.code));
    }
  }
}

String _convertErrorMessage(e) {
  switch (e) {
    case 'wrong-password':
      return 'パスワードが正しくありません';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'user-disabled':
      return 'ユーザーが無効です';
    case 'too-many-requests':
      return 'しばらく待ってからお試し下さい';
    default:
      return 'エラーが発生しました';
  }
}
