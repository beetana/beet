import 'package:beet/models/user_models/user_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/user_screens/user_calendar_screen.dart';
import 'package:beet/screens/user_screens/user_main_screen.dart';
import 'package:beet/screens/user_screens/user_task_list_screen.dart';
import 'package:beet/screens/user_setting_screens/user_setting_screen.dart';
import 'package:beet/utilities/will_pop_callback.dart';
import 'package:beet/widgets/sized_app_bar.dart';
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
            appBar: SizedAppBar(
              title: model.userName,
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
            body: Stack(
              children: <Widget>[
                Visibility(
                  visible: model.currentIndex == 0,
                  maintainState: true,
                  child: UserMainScreen(deviceWidth: deviceWidth, textScale: textScale),
                ),
                Visibility(
                  visible: model.currentIndex == 1,
                  maintainState: true,
                  child: UserCalendarScreen(textScale: textScale),
                ),
                Visibility(
                  visible: model.currentIndex == 2,
                  maintainState: true,
                  child: UserTaskListScreen(textScale: textScale),
                ),
              ],
            ),
            // ボトムナビゲーション
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
}
