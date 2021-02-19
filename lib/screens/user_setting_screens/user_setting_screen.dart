import 'package:beet/models/user_setting_models/user_setting_model.dart';
import 'package:beet/screens/user_setting_screens/user_privacy_policy_screen.dart';
import 'package:beet/screens/user_setting_screens/user_security_screen.dart';
import 'package:beet/screens/user_setting_screens/user_profile_screen.dart';
import 'package:beet/screens/user_setting_screens/user_terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingScreen extends StatelessWidget {
  UserSettingScreen({this.userID});
  final String userID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserSettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
          centerTitle: true,
        ),
        body: Consumer<UserSettingModel>(builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  'アカウント設定',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('アカウント情報'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(userID: userID),
                      ),
                    );
                  },
                ),
              ),
              Divider(
                thickness: 1.0,
                height: 1.0,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('ログインとセキュリティ'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserSecurityScreen(userID: userID),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  'アプリについて',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              Divider(
                thickness: 1.0,
                height: 1.0,
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
              Divider(
                thickness: 1.0,
                height: 1.0,
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
