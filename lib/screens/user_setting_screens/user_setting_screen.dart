import 'package:beet/models/user_setting_models/user_setting_model.dart';
import 'package:beet/screens/user_setting_screens/user_security_screen.dart';
import 'package:beet/screens/user_setting_screens/user_edit_screen.dart';
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
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 128.0,
                        height: 128.0,
                        child: CircleAvatar(
                          backgroundImage: model.userImageURL.isNotEmpty
                              ? NetworkImage(model.userImageURL)
                              : AssetImage('images/test_user_image.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          model.userName != null
                              ? model.userName
                              : 'Loading...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                        builder: (context) => UserEditScreen(
                          userID: userID,
                          userName: model.userName,
                          userImageURL: model.userImageURL,
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
                    model.init(userID: userID);
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
