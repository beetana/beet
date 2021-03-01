import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/user_screens/user_task_list_screen.dart';
import 'package:beet/screens/user_setting_screens/user_setting_screen.dart';
import 'package:beet/screens/user_screens/user_calendar_screen.dart';
import 'package:beet/screens/user_screens/user_main_screen.dart';
import 'package:beet/will_pop_callback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  UserScreen({this.userID});
  final String userID;

  @override
  Widget build(BuildContext context) {
    final List<Widget> switchBody = [
      UserMainScreen(userID: userID),
      UserCalendarScreen(userID: userID),
      UserTaskListScreen(userID: userID),
    ];
    return ChangeNotifierProvider<UserModel>(
      create: (_) => UserModel()..init(userID: userID, context: context),
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
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserSettingScreen(
                            userID: userID,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      model.init(userID: userID);
                    },
                  ),
                ],
              ),
              body: switchBody[model.currentIndex],
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
}
