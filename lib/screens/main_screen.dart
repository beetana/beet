import 'package:beet/models/main_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..init(),
      child: Consumer<MainModel>(builder: (context, model, child) {
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
                      builder: (context) => SettingScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                  model.init();
                },
              ),
            ],
          ),
          body: ListView.builder(
              padding: const EdgeInsets.only(
                top: 32.0,
                left: 16.0,
                right: 16.0,
              ),
              itemCount: model.schedules.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Material(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: 30.0,
                    ),
                    color: Colors.grey,
                    child:
                        Center(child: Text('sample ${model.schedules[index]}')),
                  ),
                );
              }),
          bottomNavigationBar: BottomNavigationBar(
            // TODO 画面の切り替え
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
      }),
    );
  }
}
