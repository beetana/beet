import 'package:beet/constants.dart';
import 'package:beet/models/group_setting_models/group_setting_model.dart';
import 'package:beet/screens/group_setting_screens/group_member_screen.dart';
import 'package:beet/screens/group_setting_screens/group_profile_screen.dart';
import 'package:beet/screens/user_setting_screens/user_privacy_policy_screen.dart';
import 'package:beet/screens/user_setting_screens/user_terms_screen.dart';
import 'package:beet/utilities/show_app_info_dialog.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatelessWidget {
  GroupSettingScreen({this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupSettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
        ),
        body: Consumer<GroupSettingModel>(builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: kDullWhiteColor,
                child: Padding(
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
              ),
              ListTile(
                title: Text('グループ情報'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GroupProfileScreen(groupId: groupId),
                    ),
                  );
                },
              ),
              ThinDivider(
                indent: 16.0,
              ),
              ListTile(
                title: Text('メンバー'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupMemberScreen(groupId: groupId),
                    ),
                  );
                },
              ),
              Container(
                width: double.infinity,
                color: kDullWhiteColor,
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
                      fullscreenDialog: true,
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
                      fullscreenDialog: true,
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
