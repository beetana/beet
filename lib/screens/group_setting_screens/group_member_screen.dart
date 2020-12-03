import 'package:beet/models/group_setting_models/group_member_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class GroupMemberScreen extends StatelessWidget {
  GroupMemberScreen({this.groupID});
  final groupID;
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
                          Share.share(
                              'beetへの招待が届いています！\n下記の2ステップで招待を承諾すると、家族間で牧場の情報を共有することができます。\n①アプリをダウンロードiOS\niOSリンク\nAndroid\nAndroidリンク\n②ダウンロード後、以下の招待リンクをタップ\nダイナミックリンク');
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
