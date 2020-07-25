import 'package:beet/screens/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:beet/screens/setting_screen.dart';

class GroupScreen extends StatelessWidget {
  final List<String> schedules = <String>['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text(
          '宇宙ネコ子',
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                  fullscreenDialog: true,
                ),
              );
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
          itemCount: schedules.length,
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
                child: Center(child: Text('sample ${schedules[index]}')),
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
