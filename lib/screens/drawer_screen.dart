import 'package:beet/models/drawer_model.dart';
import 'package:beet/screens/add_group_screen.dart';
import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrawerModel>(
      create: (_) => DrawerModel()..getUserData(),
      child: Consumer<DrawerModel>(builder: (context, model, child) {
        if (model.userName.isNotEmpty) {
          return Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(model.userName),
                  //TODO AccountEmailのスペースに何か入れる。例えば参加しているグループ数など
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
                ListTile(
                  title: Text('マイページ'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(),
                      ),
                    );
                  },
                ),
                Flexible(
                  child: ListView.builder(
                      physics: const ScrollPhysics(),
                      itemCount: model.groupName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(model.groupName[index]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupScreen(
                                  groupID: model.groupID[index],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.black54,
                      ),
                      Text('グループを追加'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddGroupScreen(userName: model.userName),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        } else {
          return Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(''),
                  accountEmail: Text(''),
                ),
                Text('Loading...'),
              ],
            ),
          );
        }
      }),
    );
  }
}
