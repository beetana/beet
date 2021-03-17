import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/constants.dart';
import 'package:beet/utilities/show_message_dialog.dart';
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
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'beet',
        description: 'beet（ビート）はバンドマン・ミュージシャンのためのシンプルな情報共有アプリです。',
        imageUrl: Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/beet-491c3.appspot.com/o/beet.png?alt=media&token=f7441793-1148-49de-8842-7b7c15a0d92c'),
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
            TextButton(
              child: Text(
                'キャンセル',
                style: kCancelButtonTextStyle,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                '参加',
                style: kEnterButtonTextStyle,
              ),
              onPressed: () async {
                showIndicator(context);
                final joiningState = await joinGroup(groupId: groupId);
                if (joiningState == JoiningState.notYet) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => GroupScreen(
                        groupId: groupId,
                      ),
                    ),
                  );
                } else if (joiningState == JoiningState.already) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await showMessageDialog(context, 'すでにグループに参加しています');
                } else if (joiningState == JoiningState.noMore) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await showMessageDialog(context, '参加できるグループの数は8個までです');
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await showMessageDialog(context, '不明なエラーです');
                }
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
      showMessageDialog(context, 'ログインしてからお試しください。');
    }
    print('complete getInitialLink');

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      if (dynamicLink != null) {
        showMessageDialog(context, 'ログインしてからお試しください。');
      }
      print('complete onLink');
    });
  }

  Future<JoiningState> joinGroup({String groupId}) async {
    String userId = user.uid;
    String userName = '';
    String userImageURL = '';
    String groupName = '';
    String groupImageURL = '';
    JoiningState joiningState;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    final groupDocRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);

    try {
      final joiningGroupQuery =
          await userDocRef.collection('joiningGroup').get();
      final joiningGroupDoc =
          await userDocRef.collection('joiningGroup').doc(groupId).get();

      if (joiningGroupQuery.size >= 8) {
        joiningState = JoiningState.noMore;
      } else if (joiningGroupDoc.exists) {
        joiningState = JoiningState.already;
      } else {
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
        joiningState = JoiningState.notYet;
      }
    } catch (e) {
      print(e);
    }
    print(joiningState);
    return joiningState;
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

enum JoiningState {
  // まだ参加してない
  notYet,

  // すでに参加している
  already,

  // これ以上は参加できない
  noMore,
}
