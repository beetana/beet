import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/user_screens/user_task_list_screen.dart';
import 'package:beet/screens/user_setting_screens/user_setting_screen.dart';
import 'package:beet/screens/user_screens/user_calendar_screen.dart';
import 'package:beet/screens/user_screens/user_main_screen.dart';
import 'package:beet/utilities/will_pop_callback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  UserScreen({this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      create: (_) => UserModel()..init(userId: userId, context: context),
      child: Consumer<UserModel>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: willPopCallback,
          child: Scaffold(
            drawer: DrawerScreen(),
            appBar: AppBar(
              title: Text(
                model.userName,
                textAlign: TextAlign.center,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettingScreen(
                          userId: userId,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                    model.init(userId: userId);
                  },
                ),
              ],
            ),
            body: _userScreenBody(context),
            bottomNavigationBar: BottomNavigationBar(
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
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _userScreenBody(BuildContext context) {
    final model = Provider.of<UserModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabScreen(currentIndex, 0, UserMainScreen(userId: userId)),
        _tabScreen(currentIndex, 1, UserCalendarScreen(userId: userId)),
        _tabScreen(currentIndex, 2, UserTaskListScreen(userId: userId)),
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
