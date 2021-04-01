import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/group_screens/group_calendar_screen.dart';
import 'package:beet/screens/group_screens/group_main_screen.dart';
import 'package:beet/screens/group_screens/group_song_list_screen.dart';
import 'package:beet/screens/group_screens/group_task_list_screen.dart';
import 'package:beet/screens/group_setting_screens/group_setting_screen.dart';
import 'package:beet/utilities/will_pop_callback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  GroupScreen({this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupModel>(
      create: (_) => GroupModel()..init(groupId: groupId),
      child: Consumer<GroupModel>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: willPopCallback,
          child: Scaffold(
            drawer: DrawerScreen(),
            appBar: AppBar(
              title: Text(
                model.groupName,
                textAlign: TextAlign.center,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupSettingScreen(groupId: groupId),
                        fullscreenDialog: true,
                      ),
                    );
                    model.init(groupId: groupId);
                  },
                ),
              ],
            ),
            body: _groupScreenBody(context),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: kBackGroundColor,
              selectedItemColor: Colors.black,
              onTap: model.onTabTapped,
              currentIndex: model.currentIndex,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'ホーム',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'カレンダー',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_bulleted),
                  label: 'やること',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  label: '持ち曲',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _groupScreenBody(BuildContext context) {
    final model = Provider.of<GroupModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabScreen(currentIndex, 0, GroupMainScreen(groupId: groupId)),
        _tabScreen(currentIndex, 1, GroupCalendarScreen(groupId: groupId)),
        _tabScreen(currentIndex, 2, GroupTaskListScreen(groupId: groupId)),
        _tabScreen(currentIndex, 3, GroupSongListScreen(groupId: groupId)),
      ],
    );
  }

  Widget _tabScreen(int currentIndex, int tabIndex, StatelessWidget screen) {
    return Visibility(
      visible: currentIndex == tabIndex,
      maintainState: true,
      child: screen,
    );
  }
}
