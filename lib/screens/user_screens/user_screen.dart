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
        if (model.userName.isNotEmpty) {
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
                    icon: Icon(
                      Icons.settings,
                    ),
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
