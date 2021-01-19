import 'package:beet/dynamic_links_services.dart';
import 'package:beet/models/group_setting_models/group_member_model.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatelessWidget {
  GroupMemberScreen({this.groupID});
  final groupID;
  final dynamicLinks = DynamicLinksServices();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMemberModel>(
      create: (_) => GroupMemberModel()..init(groupID: groupID),
      child: Consumer<GroupMemberModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('メンバー'),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: model.userNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            String userID = model.userIDs[index];
                            String userName = model.userNames[index];
                            String userImageURL = model.userImageURLs[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: userImageURL.isNotEmpty
                                    ? NetworkImage(userImageURL)
                                    : AssetImage('images/test_user_image.png'),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(
                                userName,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () async {
                                bool isMe = userID == model.myID;
                                bool isDelete = await _showMemberBottomSheet(
                                  context,
                                  isMe,
                                  userName,
                                );
                                if (isDelete == true) {
                                  model.startLoading();
                                  try {
                                    await model.deleteMember(userID: userID);
                                    isMe
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  UserScreen(userID: userID),
                                            ),
                                          )
                                        : model.init(groupID: groupID);
                                  } catch (e) {
                                    _showTextDialog(context, e.toString());
                                  }
                                  model.endLoading();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      FlatButton.icon(
                        icon: Icon(
                          Icons.group_add,
                          color: Colors.black54,
                        ),
                        label: Text('メンバーを招待'),
                        onPressed: () async {
                          model.startLoading();
                          Uri link = await dynamicLinks.createDynamicLink(
                            groupID: groupID,
                            groupName: model.groupName,
                          );
                          model.endLoading();
                          await _inviteMemberDialog(context, link);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            model.isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }
}

Future<bool> _showMemberBottomSheet(
    BuildContext context, bool isMe, String userName) async {
  String buttonText = isMe ? 'グループを退会' : 'このメンバーを削除';
  bool isDelete;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Color(0xff757575),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  FlatButton(
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.redAccent,
                    onPressed: () async {
                      isDelete =
                          await _showConfirmDialog(context, isMe, userName);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return isDelete;
}

Future<bool> _showConfirmDialog(context, isMe, userName) async {
  String titleText = isMe ? 'グループを退会しますか?' : '$userNameをグループから削除しますか?';
  String buttonText = isMe ? '退会' : '削除';
  bool isDelete;
  isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(titleText),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              buttonText,
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return isDelete;
}

Future _showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
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

Future _inviteMemberDialog(context, dynamicLink) async {
  final String inviteMessage =
      'beetのグループへの招待が届きました。\n招待リンクをタップしてグループに参加しましょう。\n▶︎まずはbeetをダウンロード\niOS\niOSリンク\nAndroid\nAndroidリンク\n▶︎ダウンロード後、以下の招待リンクをタップ\n$dynamicLink';
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text('次のメッセージをシェアしてグループに参加してもらいましょう。'),
        titleTextStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        titlePadding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        children: [
          SimpleDialogOption(
            child: Text(
              inviteMessage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SimpleDialogOption(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                  child: Text(
                'メッセージをコピー',
                style: TextStyle(color: Colors.blue),
              )),
            ),
            onPressed: () async {
              final ClipboardData data = ClipboardData(text: inviteMessage);
              await Clipboard.setData(data);
              await _showTextDialog(context, 'コピーしました!');
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
