import 'package:beet/models/group_model.dart';
import 'package:beet/screens/drawer_screen.dart';
import 'package:beet/screens/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  GroupScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupModel>(
      create: (_) => GroupModel(),
      child: Consumer<GroupModel>(builder: (context, model, child) {
        return StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('groups')
              .document(groupID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              );
            }
            final name = snapshot.data['groupName'];
            return Scaffold(
              drawer: DrawerScreen(),
              appBar: AppBar(
                title: Text(name),
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
                        child: Center(
                            child: Text('sample ${model.schedules[index]}')),
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
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music),
                    title: Text('持ち曲'),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
