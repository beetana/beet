import 'package:beet/models/group_setting_models/group_member_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatelessWidget {
  GroupMemberScreen({this.groupID, this.groupName});
  final groupID;
  final groupName;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMemberModel>(
      create: (_) =>
          GroupMemberModel()..init(groupID: groupID, groupName: groupName),
      child: Consumer<GroupMemberModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('メンバー'),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton.icon(
                        icon: Icon(
                          Icons.group_add,
                          color: Colors.black54,
                        ),
                        label: Text('メンバーを招待'),
                        onPressed: () async {
                          await model.createDynamicLink();
                          await _inviteMemberDialog(context, model.dynamicLink);
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

Future _showTextDialog(context, message) async {
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

Future _inviteMemberDialog(context, dynamicLink) async {
  final String inviteMessage =
      'beetのグループへの招待が届きました。\n招待リンクをタップしてグループに参加しましょう。\n▶︎まずはbeetをダウンロード\niOS\niOSリンク\nAndroid\nAndroidリンク\n▶︎ダウンロード後、以下の招待リンクをタップ\n$dynamicLink';
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
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
                borderRadius: BorderRadius.circular(5.0),
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
