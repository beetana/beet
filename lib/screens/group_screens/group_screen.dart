import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/group_screens/group_calendar_screen.dart';
import 'package:beet/screens/group_screens/group_main_screen.dart';
import 'package:beet/screens/group_screens/group_song_list_screen.dart';
import 'package:beet/screens/group_screens/group_task_list_screen.dart';
import 'package:beet/screens/group_setting_screens/group_setting_screen.dart';
import 'package:beet/will_pop_callback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  GroupScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    final List<Widget> switchBody = [
      GroupMainScreen(groupID: groupID),
      GroupCalendarScreen(groupID: groupID),
      GroupTaskListScreen(groupID: groupID),
      GroupSongListScreen(groupID: groupID),
    ];

    return ChangeNotifierProvider<GroupModel>(
      create: (_) => GroupModel()..init(groupID: groupID),
      child: Consumer<GroupModel>(builder: (context, model, child) {
        if (model.groupName.isNotEmpty) {
          return WillPopScope(
            onWillPop: willPopCallback,
            child: Scaffold(
              drawer: DrawerScreen(),
              appBar: AppBar(
                title: Text(
                  model.groupName,
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
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
                type: BottomNavigationBarType.fixed,
                backgroundColor: kBackGroundColor,
                selectedItemColor: Colors.black,
                onTap: model.onTabTapped,
                currentIndex: model.currentIndex,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'ホーム',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'カレンダー',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.format_list_bulleted),
                    label: 'やること',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music),
                    label: '持ち曲',
                  ),
                ],
              ),
            ),
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
