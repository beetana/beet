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
      create: (_) => DrawerModel()..init(),
      child: Consumer<DrawerModel>(builder: (context, model, child) {
        if (model.userName.isNotEmpty) {
          return Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(model.userName),
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: model.userImageURL.isNotEmpty
                        ? NetworkImage(model.userImageURL)
                        : AssetImage('images/test_user_image.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                ListTile(
                  title: Text('マイページ'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(userID: model.userID),
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
                FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Colors.black54,
                  ),
                  label: Text('グループを作成'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddGroupScreen(
                          userName: model.userName,
                          userImageURL: model.userImageURL,
                        ),
                      ),
                    );
                  },
                ),
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
