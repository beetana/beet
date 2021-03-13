import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksServices {
  Uri dynamicLink;
  BuildContext context;
  Auth.User user = Auth.FirebaseAuth.instance.currentUser;

  Future<Uri> createDynamicLink({String groupId, String groupName}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://beetana.page.link',
      link: Uri.parse('https://beetana.page.link/?id=$groupId&name=$groupName'),
      androidParameters: AndroidParameters(
        packageName: 'com.beetana.beet',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.beetana.beet',
        minimumVersion: '1',
        fallbackUrl:
            Uri.parse('https://apps.apple.com/jp/app/memow/id1518582060'),
      ),
    );

    Uri link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    dynamicLink = shortenedLink.shortUrl;
    print('$dynamicLink');
    print('$dynamicLink?d=1');
    return dynamicLink;
  }

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
    String invitedGroupId = '';
    String invitedGroupName = '';

    final Uri deepLink = data?.link;
    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      invitedGroupId = queryParams['id'];
      invitedGroupName = queryParams['name'];
      invitedDialog(context, invitedGroupId, invitedGroupName);

      print(queryParams);
      print('招待されたグループのIDは${queryParams['id']}');
      print('招待されたグループの名前は${queryParams['name']}');
    }
  }

  Future invitedDialog(context, groupId, groupName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$groupNameに招待されました。\n参加しますか？'),
          actions: [
            FlatButton(
              child: Text('参加'),
              onPressed: () async {
                showIndicator(context);
                final isAlreadyJoin = await joinGroup(groupId: groupId);
                if (isAlreadyJoin == true) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await alertMessageDialog(context, 'すでにグループに参加しています');
                } else {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => GroupScreen(
                        groupId: groupId,
                      ),
                    ),
                  );
                }
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

  void promptLogin(context) async {
    this.context = context;

    PendingDynamicLinkData link =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      alertMessageDialog(context, 'ログインしてからお試しください。');
    }
    print('complete getInitialLink');

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      if (dynamicLink != null) {
        alertMessageDialog(context, 'ログインしてからお試しください。');
      }
      print('complete onLink');
    });
  }

  Future alertMessageDialog(context, message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> joinGroup({String groupId}) async {
    String userId = user.uid;
    String userName = '';
    String userImageURL = '';
    String groupName = '';
    String groupImageURL = '';
    bool isAlreadyJoin = false;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    final groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);

    try {
      final joiningGroupDoc =
          await userDocRef.collection('joiningGroup').doc(groupId).get();
      print(!joiningGroupDoc.exists);

      if (!joiningGroupDoc.exists) {
        final userDoc = await userDocRef.get();
        userName = userDoc['name'];
        userImageURL = userDoc['imageURL'];

        await groupDocRef.collection('groupUsers').doc(userId).set({
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });

        final groupDoc = await groupDocRef.get();
        groupName = groupDoc['name'];
        groupImageURL = groupDoc['imageURL'];

        await userDocRef.collection('joiningGroup').doc(groupId).set({
          'name': groupName,
          'imageURL': groupImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });
      } else {
        isAlreadyJoin = true;
      }
    } catch (e) {
      print(e);
    }
    print(isAlreadyJoin);
    return isAlreadyJoin;
  }

  void showIndicator(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
