import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late DocumentReference groupDocRef;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    myId = _auth.currentUser!.uid;
    groupDocRef = _firestore.collection('groups').doc(groupId);

    try {
      final DocumentSnapshot groupDoc = await groupDocRef.get();
      groupName = groupDoc['name'];
      groupImageURL = groupDoc['imageURL'];
      await fetchMembers();
    } catch (e) {
      print(e);
    }
    endLoading();
  }

  Future<void> fetchMembers() async {
    try {
      final QuerySnapshot membersQuery =
          await groupDocRef.collection('members').get();
      usersId = (membersQuery.docs.map((doc) => doc.id).toList());
      usersName = (membersQuery.docs.map((doc) => doc['name'].toString()).toList());
      usersImageURL =
          (membersQuery.docs.map((doc) => doc['imageURL'].toString()).toList());
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future<int> checkMemberCount() async {
    int memberCount;

    try {
      final QuerySnapshot membersQuery =
          await groupDocRef.collection('members').get();
      memberCount = membersQuery.size;
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
    return memberCount;
  }

  Future<void> deleteMember({required String userId}) async {
    final WriteBatch batch = _firestore.batch();
    final DocumentReference joiningGroupDocRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('joiningGroups')
        .doc(groupId);
    final DocumentReference memberDocRef =
        groupDocRef.collection('members').doc(userId);
    batch.delete(joiningGroupDocRef);
    batch.delete(memberDocRef);

    try {
      await batch.commit();
    } catch (e) {
      print(e);
      throw ('エラーが発生しました');
    }
  }

  Future<void> deleteGroup({required String userId}) async {
    final joiningGroupDocRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('joiningGroups')
        .doc(groupId);
    final WriteBatch batch = _firestore.batch();

    try {
      // Firebase Storage内のグループのプロフィール画像を削除
      if (groupImageURL.isNotEmpty) {
        await _storage.ref().child("groupImage/$groupId").delete();
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
