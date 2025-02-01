import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/user_screens/user_calendar_screen.dart';
import 'package:beet/screens/user_screens/user_main_screen.dart';
import 'package:beet/screens/user_screens/user_task_list_screen.dart';
import 'package:beet/screens/user_setting_screens/user_setting_screen.dart';
import 'package:beet/utilities/will_pop_callback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // コメントの数字はiPhone12ProMax換算
    final double deviceWidth = MediaQuery.of(context).size.width; // 428
    final double textScale = MediaQuery.of(context).textScaleFactor;

    return ChangeNotifierProvider<UserModel>(
      create: (_) => UserModel()..init(context: context),
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
                        builder: (context) => UserSettingScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                    model.init(context: context);
                  },
                ),
              ],
            ),
            body: _userScreenBody(context, deviceWidth, textScale),
            bottomNavigationBar: BottomNavigationBar(
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

  Widget _userScreenBody(BuildContext context, double deviceWidth, double textScale) {
    final model = Provider.of<UserModel>(context);
    final currentIndex = model.currentIndex;
    return Stack(
      children: <Widget>[
        _tabScreen(
          currentIndex,
          0,
          UserMainScreen(deviceWidth: deviceWidth, textScale: textScale),
        ),
        _tabScreen(
          currentIndex,
          1,
          UserCalendarScreen(textScale: textScale),
        ),
        _tabScreen(
          currentIndex,
          2,
          UserTaskListScreen(textScale: textScale),
        ),
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
