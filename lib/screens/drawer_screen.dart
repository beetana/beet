import 'package:flutter/material.dart';
import 'package:beet/screens/my_page_screen.dart';
import 'package:beet/screens/group_screen.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("べーたな"),
            accountEmail: Text("@beetana2beetana"),
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
                  builder: (context) => MyPageScreen(),
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
          ListTile(
            title: Text('Salmon Sperm Sparx'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
