import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GroupMemberModel extends ChangeNotifier {
  String groupId = '';
  String groupName = '';
  String groupImageURL = '';
  String myId = '';
  List<String> usersId = [];
  List<String> usersName = [];
  List<String> usersImageURL = [];
  bool isLoading = false;
  final firestore = FirebaseFirestore.instance;

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
    this.myId = Auth.FirebaseAuth.instance.currentUser.uid;
    try {
      DocumentSnapshot groupDoc =
          await firestore.collection('groups').doc(groupId).get();
      this.groupName = groupDoc['name'];
      this.groupImageURL = groupDoc['imageURL'];
      await fetchMembers();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future fetchMembers() async {
    try {
      final membersQuery = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .get();
      this.usersId = (membersQuery.docs.map((doc) => doc.id).toList());
      this.usersName =
          (membersQuery.docs.map((doc) => doc['name'].toString()).toList());
      this.usersImageURL =
          (membersQuery.docs.map((doc) => doc['imageURL'].toString()).toList());
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future<int> checkMemberCount() async {
    int memberCount;
    try {
      final membersQuery = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .get();
      memberCount = membersQuery.size;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    return memberCount;
  }

  Future deleteMember({String userId}) async {
    final batch = firestore.batch();
    final joiningGroupDocRef = firestore
        .collection('users')
        .doc(userId)
        .collection('joiningGroups')
        .doc(groupId);
    final memberDocRef = firestore
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(userId);
    batch.delete(joiningGroupDocRef);
    batch.delete(memberDocRef);
    try {
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future deleteGroup({String userId}) async {
    final groupDocRef = firestore.collection('groups').doc(groupId);
    final joiningGroupDocRef = firestore
        .collection('users')
        .doc(userId)
        .collection('joiningGroups')
        .doc(groupId);
    final batch = firestore.batch();
    try {
      // Firebase Storage内のグループのプロフィール画像を削除
      if (groupImageURL.isNotEmpty) {
        await FirebaseStorage.instance
            .ref()
            .child("groupImage/$groupId")
            .delete();
      }
      // ユーザーのjoiningGroupからこのグループを削除
      batch.delete(joiningGroupDocRef);
      // グループのドキュメントを削除するとCloud FunctionsのdeleteGroupがトリガーされ、
      // そのグループのサブコレクションも削除される
      batch.delete(groupDocRef);
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }
}
