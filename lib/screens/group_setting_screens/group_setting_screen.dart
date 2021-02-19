import 'package:beet/models/group_setting_models/group_setting_model.dart';
import 'package:beet/screens/group_setting_screens/group_member_screen.dart';
import 'package:beet/screens/group_setting_screens/group_profile_screen.dart';
import 'package:beet/screens/user_setting_screens/user_privacy_policy_screen.dart';
import 'package:beet/screens/user_setting_screens/user_terms_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatelessWidget {
  GroupSettingScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupSettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
          centerTitle: true,
        ),
        body: Consumer<GroupSettingModel>(builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 8.0,
                  left: 16.0,
                ),
                child: Text(
                  'グループ設定',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BasicDivider(),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('グループ情報'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupProfileScreen(groupID: groupID),
                      ),
                    );
                  },
                ),
              ),
              BasicDivider(
                indent: 16.0,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('メンバー'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupMemberScreen(groupID: groupID),
                      ),
                    );
                  },
                ),
              ),
              BasicDivider(
                indent: 16.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 8.0,
                  left: 16.0,
                ),
                child: Text(
                  'アプリについて',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BasicDivider(),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('利用規約'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserTermsScreen(),
                      ),
                    );
                  },
                ),
              ),
              BasicDivider(
                indent: 16.0,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('プライバシーポリシー'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
              ),
              BasicDivider(
                indent: 16.0,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('アプリの詳細'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    _showAppInfoDialog(context);
                  },
                ),
              ),
              BasicDivider(
                indent: 16.0,
              ),
            ],
          );
        }),
      ),
    );
  }
}

Future _showAppInfoDialog(context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('images/app_icon.png'),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'beet',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '1.0.0',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  '2021  Kohei Tanabe',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('ライセンスを表示'),
            onPressed: () {
              showLicensePage(context: context);
            },
          ),
          FlatButton(
            child: Text('閉じる'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
