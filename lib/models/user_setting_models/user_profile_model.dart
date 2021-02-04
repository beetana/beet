import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class UserProfileModel extends ChangeNotifier {
  String userID = '';
  String userName = '';
  String userImageURL = '';
  File imageFile;
  bool isLoading = false;
  List<String> joiningGroupsID = [];
  final _auth = Auth.FirebaseAuth.instance;

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
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child("userImage/$userID")
          .putFile(imageFile);
      userImageURL = await snapshot.ref.getDownloadURL();
      final joiningGroups = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('joiningGroup')
          .get();
      joiningGroupsID = (joiningGroups.docs.map((doc) => doc.id).toList());
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'imageURL': userImageURL,
      });
      for (String groupID in joiningGroupsID) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupID)
            .collection('groupUsers')
            .doc(userID)
            .update({
          'imageURL': userImageURL,
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

  Future deleteAccount({String password}) async {
    final user = _auth.currentUser;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userID);
    try {
      await user.reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
        email: user.email,
        password: password,
      ));
      // Firebase Storageにあるプロフィール画像を削除
      if (userImageURL.isNotEmpty) {
        await FirebaseStorage.instance
            .ref()
            .child("userImage/$userID")
            .delete();
      }
      // 参加しているグループから自分のドキュメントを削除
      final joiningGroups = await userDocRef.collection('joiningGroup').get();
      joiningGroupsID = (joiningGroups.docs.map((doc) => doc.id).toList());
      for (String groupID in joiningGroupsID) {
        final groupDocRef =
            FirebaseFirestore.instance.collection('groups').doc(groupID);
        await groupDocRef.collection('groupUsers').doc(userID).delete();
        await groupDocRef.update({
          'userCount': FieldValue.increment(-1),
        });
      }
      // ユーザーの認証情報を削除
      await user.delete();
      // ユーザーのドキュメントを削除するとCloud FunctionsのdeleteUserがトリガーされ、
      // userDocRef以下のサブコレクションも削除される
      await userDocRef.delete();
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
      return '不明なエラーです';
  }
}
