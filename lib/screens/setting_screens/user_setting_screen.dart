import 'package:beet/models/setting_models/user_setting_model.dart';
import 'package:beet/screens/setting_screens/user_image_update_screen.dart';
import 'package:beet/screens/setting_screens/user_name_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingScreen extends StatelessWidget {
  UserSettingScreen({this.userID});
  final String userID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserSettingModel()..init(userID: userID),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
        ),
        body: Consumer<UserSettingModel>(builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  top: 24.0,
                  bottom: 8.0,
                ),
                child: Text(
                  'ユーザー設定',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('アカウント名の変更'),
                  subtitle: Text(model.userName),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserNameUpdateScreen(
                          userID: userID,
                          userName: model.userName,
                        ),
                      ),
                    );
                    model.init(userID: userID);
                  },
                ),
              ),
              Divider(
                height: 0.5,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('アイコンの変更'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserImageUpdateScreen(
                          userID: userID,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  top: 24.0,
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
                  title: Text('プライバシーポリシー'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {},
                ),
              ),
              Divider(
                height: 0.5,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('利用規約'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {},
                ),
              ),
              Divider(
                height: 0.5,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('アプリ情報'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {},
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
