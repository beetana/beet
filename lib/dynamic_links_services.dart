import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksServices {
  Uri dynamicLink;
  BuildContext context;
  Auth.User user = Auth.FirebaseAuth.instance.currentUser;

  Future<Uri> createDynamicLink({String groupID, String groupName}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://beetana.page.link',
      link: Uri.parse('https://beetana.page.link/?id=$groupID&name=$groupName'),
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
    String invitedGroupID = '';
    String invitedGroupName = '';

    final Uri deepLink = data?.link;
    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      invitedGroupID = queryParams['id'];
      invitedGroupName = queryParams['name'];
      invitedDialog(context, invitedGroupID, invitedGroupName);

      print(queryParams);
      print('招待されたグループのIDは${queryParams['id']}');
      print('招待されたグループの名前は${queryParams['name']}');
    }
  }

  Future invitedDialog(context, groupID, groupName) async {
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
                showIndicator(context);
                final isAlreadyJoin = await joinGroup(groupID);
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
                        groupID: groupID,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          title: Text(message),
          actions: <Widget>[
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

  Future<bool> joinGroup(groupID) async {
    String userID = user.uid;
    String userName = '';
    String userImageURL = '';
    String groupName = '';
    String groupImageURL = '';
    bool isAlreadyJoin = false;
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
        userImageURL = userDoc['imageURL'];

        final groupDoc = await groupDocRef.get();
        groupName = groupDoc['name'];
        groupImageURL = groupDoc['imageURL'];

        await groupDocRef.collection('groupUsers').doc(userID).set({
          'name': userName,
          'imageURL': userImageURL,
          'joinedAt': Timestamp.now(),
        });
        await groupDocRef.update({
          'userCount': FieldValue.increment(1),
        });
        await userDocRef.collection('joiningGroup').doc(groupID).set({
          'name': groupName,
          'imageURL': groupImageURL,
          'joinedAt': Timestamp.now(),
        });
        await userDocRef.update({
          'groupCount': FieldValue.increment(1),
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
