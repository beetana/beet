import 'package:beet/constants.dart';
import 'package:beet/models/user_setting_models/user_setting_model.dart';
import 'package:beet/screens/inquiry_screen.dart';
import 'package:beet/screens/privacy_policy_screen.dart';
import 'package:beet/screens/manual_screen.dart';
import 'package:beet/screens/user_setting_screens/user_security_screen.dart';
import 'package:beet/screens/user_setting_screens/user_profile_screen.dart';
import 'package:beet/screens/terms_screen.dart';
import 'package:beet/utilities/show_app_info_dialog.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserSettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('設定'),
        ),
        body: Consumer<UserSettingModel>(builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Container(
                color: kDullWhiteColor,
                width: double.infinity,
                child: const Padding(
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
                title: const Text('アカウント情報'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(),
                    ),
                  );
                },
              ),
              ThinDivider(indent: 16.0),
              ListTile(
                title: const Text('ログインとセキュリティ'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSecurityScreen(),
                    ),
                  );
                },
              ),
              Container(
                color: kDullWhiteColor,
                width: double.infinity,
                child: const Padding(
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
                title: const Text('アプリの使い方'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManualScreen(),
                      // UserProfileScreen(),
                    ),
                  );
                },
              ),
              ThinDivider(indent: 16.0),
              ListTile(
                title: const Text('ご意見・お問い合わせ'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InquiryScreen(),
                      // UserProfileScreen(),
                    ),
                  );
                },
              ),
              ThinDivider(indent: 16.0),
              ListTile(
                title: const Text('利用規約'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
              ThinDivider(indent: 16.0),
              ListTile(
                title: const Text('プライバシーポリシー'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
              ThinDivider(indent: 16.0),
              ListTile(
                title: const Text('アプリの詳細'),
                trailing: const Icon(Icons.keyboard_arrow_right),
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
