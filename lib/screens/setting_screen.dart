import 'package:beet/screens/re_name_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Column(
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
              title: Text('名前の変更'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReNameScreen()),
                );
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
              onTap: () {},
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
      ),
    );
  }
}
