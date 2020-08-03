import 'package:beet/models/drawer_model.dart';
import 'package:beet/screens/add_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:beet/screens/main_screen.dart';
import 'package:beet/screens/group_screen.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrawerModel>(
      create: (_) => DrawerModel()..getUserData(),
      child: Consumer<DrawerModel>(builder: (context, model, child) {
        return Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(model.name),
                accountEmail: Text(model.email),
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
                      builder: (context) => MainScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('宇宙ネコ子'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupScreen(),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text('グループを追加'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddGroupScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
