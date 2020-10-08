import 'package:beet/models/user_models/user_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/setting_screens/user_setting_screen.dart';
import 'package:beet/screens/user_screens/user_calendar_screen.dart';
import 'package:beet/screens/user_screens/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      create: (_) => UserModel()..init(),
      child: Consumer<UserModel>(builder: (context, model, child) {
        final List<Widget> switchBody = [
          UserMainScreen(userID: model.userID),
          UserCalendarScreen(userID: model.userID),
        ];
        if (model.userName.isNotEmpty) {
          return Scaffold(
            drawer: DrawerScreen(),
            appBar: AppBar(
              title: Text(model.userName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettingScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                    model.init();
                  },
                ),
              ],
            ),
            body: switchBody[model.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.cyan,
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
              ],
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
