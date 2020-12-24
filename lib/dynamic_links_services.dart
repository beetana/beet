import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksServices {
  BuildContext context;
  void fetchLinkData(context) async {
    this.context = context;
    PendingDynamicLinkData link =
        await FirebaseDynamicLinks.instance.getInitialLink();
    handleLinkData(link);
    print('complete getInitialLink');

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink);
      print('complete onLink');
    });
  }

  void handleLinkData(PendingDynamicLinkData data) {
    String invitedGroupID;
    String invitedGroupName;

    final Uri deepLink = data?.link;
    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      invitedGroupID = queryParams['id'];
      invitedGroupName = queryParams['name'];
      showTextDialog(context, invitedGroupID, invitedGroupName);

      print(queryParams);
      print('招待されたグループのIDは${queryParams['id']}');
      print('招待されたグループの名前は${queryParams['name']}');
    }
  }

  Future showTextDialog(context, groupID, groupName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          title: Text('$groupNameに招待されました。\n参加しますか？'),
          actions: <Widget>[
            FlatButton(
              child: Text('参加'),
              onPressed: () async {
                await joinGroup(groupID, groupName);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GroupScreen(
                      groupID: groupID,
                    ),
                  ),
                );
              },
            ),
            FlatButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future joinGroup(groupID, groupName) async {
    String userID = FirebaseAuth.instance.currentUser.uid;
    String userName;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userID);
    final groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(groupID);

    try {
      final joiningGroupDoc =
          await userDocRef.collection('joiningGroup').doc(groupID).get();
      print(!joiningGroupDoc.exists);

      if (!joiningGroupDoc.exists) {
        final userDoc = await userDocRef.get();
        userName = userDoc['name'];
        await groupDocRef.collection('groupUsers').doc(userID).set({
          'userID': userID,
          'userName': userName,
          'joinedAt': Timestamp.now(),
        });
        await groupDocRef.update({
          'userCount': FieldValue.increment(1),
        });
        await userDocRef.collection('joiningGroup').doc(groupID).set({
          'name': groupName,
          'joinedAt': Timestamp.now(),
        });
        await userDocRef.update({
          'groupCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
