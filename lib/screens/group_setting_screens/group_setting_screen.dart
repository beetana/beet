import 'package:beet/models/group_setting_models/group_setting_model.dart';
import 'package:beet/screens/group_setting_screens/group_member_screen.dart';
import 'package:beet/screens/group_setting_screens/group_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatelessWidget {
  GroupSettingScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupSettingModel()..init(groupID: groupID),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
        ),
        body: Consumer<GroupSettingModel>(builder: (context, model, child) {
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
                  'グループ設定',
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
                          backgroundImage: model.groupImageURL != null
                              ? NetworkImage(model.groupImageURL)
                              : AssetImage('images/test_user_image.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        model.groupName != null
                            ? model.groupName
                            : 'Loading...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text('グループ情報'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupUpdateScreen(
                          groupID: groupID,
                          groupName: model.groupName,
                          groupImageURL: model.groupImageURL,
                        ),
                      ),
                    );
                    model.init(groupID: groupID);
                  },
                ),
              ),
              Divider(
                height: 0.5,
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
                        builder: (context) => GroupMemberScreen(),
                      ),
                    );
                    model.init(groupID: groupID);
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
