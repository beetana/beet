import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/constants.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksServices {
  BuildContext context;

  Future<Uri> createDynamicLink({String groupId, String groupName}) async {
    final String domain = kFirebaseEnvironment
        ? 'https://beetana.page.link'
        : 'https://beetdev.page.link';
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: domain,
      link: Uri.parse('$domain/?id=$groupId&name=$groupName'),
      androidParameters: AndroidParameters(
        packageName: 'com.beetana.beet',
        minimumVersion: 1,
        fallbackUrl: Uri.parse(
            'https://play.google.com/store/apps/details?id=com.beetana.beet'),
      ),
      iosParameters: IosParameters(
        bundleId: 'com.beetana.beet',
        minimumVersion: '1',
        fallbackUrl:
            Uri.parse('https://apps.apple.com/jp/app/beet/id1562073325'),
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'beet',
        description: 'OPENボタンからアプリを開いてグループに参加しましょう。',
        imageUrl: Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/beet-491c3.appspot.com/o/beet.png?alt=media&token=f7441793-1148-49de-8842-7b7c15a0d92c'),
      ),
    );

    final Uri link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    final Uri dynamicLink = shortenedLink.shortUrl;
    print('$dynamicLink');
    print('$dynamicLink?d=1');
    return dynamicLink;
  }

  Future<void> fetchLinkData({BuildContext context}) async {
    this.context = context;
    final PendingDynamicLinkData link =
        await FirebaseDynamicLinks.instance.getInitialLink();
    handleLinkData(data: link);
    print('complete getInitialLink');

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(data: dynamicLink);
      print('complete onLink');
    });
  }

  void handleLinkData({PendingDynamicLinkData data}) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      final Map<String, String> queryParams = deepLink.queryParameters;
      final String invitedGroupId = queryParams['id'];
      final String invitedGroupName = queryParams['name'];
      invitedDialog(
        context: context,
        groupId: invitedGroupId,
        groupName: invitedGroupName,
      );

      print(queryParams);
      print('招待されたグループのIDは${queryParams['id']}');
      print('招待されたグループの名前は${queryParams['name']}');
    }
  }

  Future<void> invitedDialog(
      {BuildContext context, String groupId, String groupName}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$groupNameに招待されました。\n参加しますか？'),
          actions: [
            TextButton(
              child: const Text(
                'キャンセル',
                style: kCancelButtonTextStyle,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                '参加',
                style: kEnterButtonTextStyle,
              ),
              onPressed: () async {
                showIndicator(context: context);
                final JoiningState joiningState =
                    await joinGroup(groupId: groupId);
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
                  await showMessageDialog(context, 'すでにグループに参加しています。');
                } else if (joiningState == JoiningState.noMore) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await showMessageDialog(context, '参加できるグループの数は8個までです。');
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await showMessageDialog(context, 'エラーが発生しました。');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> promptLogin({BuildContext context}) async {
    final PendingDynamicLinkData link =
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
    JoiningState joiningState;
    final String userId = FirebaseAuth.instance.currentUser.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference userDocRef =
        firestore.collection('users').doc(userId);
    final DocumentReference groupDocRef =
        firestore.collection('groups').doc(groupId);

    try {
      final QuerySnapshot joiningGroupsQuery =
          await userDocRef.collection('joiningGroups').get();
      final DocumentSnapshot joiningGroupDoc =
          await userDocRef.collection('joiningGroups').doc(groupId).get();

      if (joiningGroupsQuery.size >= 8) {
        joiningState = JoiningState.noMore;
      } else if (joiningGroupDoc.exists) {
        joiningState = JoiningState.already;
      } else {
        final DocumentSnapshot userDoc = await userDocRef.get();
        final String userName = userDoc['name'];
        final String userImageURL = userDoc['imageURL'];

        await groupDocRef.collection('members').doc(userId).set({
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': FieldValue.serverTimestamp(),
        });

        final DocumentSnapshot groupDoc = await groupDocRef.get();
        final String groupName = groupDoc['name'];
        final String groupImageURL = groupDoc['imageURL'];

        await userDocRef.collection('joiningGroups').doc(groupId).set({
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

  void showIndicator({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          child: const Center(
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
