import 'package:beet/constants.dart';
import 'package:beet/models/group_setting_models/group_setting_model.dart';
import 'package:beet/screens/group_setting_screens/group_member_screen.dart';
import 'package:beet/screens/group_setting_screens/group_profile_screen.dart';
import 'package:beet/screens/inquiry_screen.dart';
import 'package:beet/screens/manual_screen.dart';
import 'package:beet/screens/privacy_policy_screen.dart';
import 'package:beet/screens/terms_screen.dart';
import 'package:beet/utilities/show_app_info_dialog.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatelessWidget {
  final String groupId;

  GroupSettingScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupSettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('設定'),
        ),
        body: Consumer<GroupSettingModel>(builder: (context, model, child) {
          return Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: kDullWhiteColor,
                child: const Padding(
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
                title: const Text('グループ情報'),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupProfileScreen(groupId: groupId),
                    ),
                  );
                },
              ),
              ThinDivider(indent: 16.0),
              ListTile(
                title: const Text('メンバー'),
                trailing: const Icon(Icons.keyboard_arrow_right),
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
