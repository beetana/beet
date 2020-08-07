import 'package:beet/models/group_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/group_calendar_screen.dart';
import 'package:beet/screens/group_main_screen.dart';
import 'package:beet/screens/group_song_list_screen.dart';
import 'package:beet/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  GroupScreen({this.groupID});
  final String groupID;
  final List<Widget> _children = [
    GroupMainScreen(),
    GroupCalendarScreen(),
    GroupSongListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupModel>(
      create: (_) => GroupModel()..init(groupID),
      child: Consumer<GroupModel>(builder: (context, model, child) {
        return Scaffold(
          drawer: DrawerScreen(),
          appBar: AppBar(
            title: Text(model.groupName),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ],
          ),
          body: _children[model.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: model.onTabTapped,
            currentIndex: model.currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('ホーム'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('カレンダー'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                title: Text('持ち曲'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
