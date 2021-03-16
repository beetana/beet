import 'package:beet/constants.dart';
import 'package:beet/models/user_setting_models/user_setting_model.dart';
import 'package:beet/screens/user_setting_screens/user_privacy_policy_screen.dart';
import 'package:beet/screens/user_setting_screens/user_security_screen.dart';
import 'package:beet/screens/user_setting_screens/user_profile_screen.dart';
import 'package:beet/screens/user_setting_screens/user_terms_screen.dart';
import 'package:beet/utilities/show_app_info_dialog.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingScreen extends StatelessWidget {
  UserSettingScreen({this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserSettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
        ),
        body: Consumer<UserSettingModel>(builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Container(
                color: kDullWhiteColor,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                    left: 16.0,
                  ),
                  child: Text(
                    'アカウント設定',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('アカウント情報'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: userId),
                    ),
                  );
                },
              ),
              ThinDivider(
                indent: 16.0,
              ),
              ListTile(
                title: Text('ログインとセキュリティ'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSecurityScreen(userId: userId),
                    ),
                  );
                },
              ),
              Container(
                color: kDullWhiteColor,
                width: double.infinity,
                child: Padding(
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
              ),
              ListTile(
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
              ThinDivider(
                indent: 16.0,
              ),
              ListTile(
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
              ThinDivider(
                indent: 16.0,
              ),
              ListTile(
                title: Text('アプリの詳細'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  showAppInfoDialog(context);
                },
              ),
              Expanded(
                child: Container(
                  color: kDullWhiteColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
