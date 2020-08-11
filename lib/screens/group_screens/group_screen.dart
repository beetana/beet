import 'package:beet/models/group_models/group_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/group_screens/add_song_screen.dart';
import 'package:beet/screens/group_screens/group_calendar_screen.dart';
import 'package:beet/screens/group_screens/group_main_screen.dart';
import 'package:beet/screens/group_screens/group_song_list_screen.dart';
import 'package:beet/screens/setting_screens/group_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  GroupScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    final List<Widget> switchBody = [
      GroupMainScreen(),
      GroupCalendarScreen(),
      GroupSongListScreen(groupID: groupID),
    ];

    Widget switchFAB(int index) {
      if (index == 0) {
        return null;
      } else {
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSongScreen(groupID: groupID),
                fullscreenDialog: true,
              ),
            );
          },
        );
      }
    }

    return ChangeNotifierProvider<GroupModel>(
      create: (_) => GroupModel()..init(groupID: groupID),
      child: Consumer<GroupModel>(builder: (context, model, child) {
        if (model.groupName.isNotEmpty) {
          return Scaffold(
            drawer: DrawerScreen(),
            appBar: AppBar(
              title: Text(model.groupName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupSettingScreen(groupID: groupID),
                        fullscreenDialog: true,
                      ),
                    );
                    model.init(groupID: groupID);
                  },
                ),
              ],
            ),
            body: switchBody[model.currentIndex],
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
            floatingActionButton: switchFAB(model.currentIndex),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
