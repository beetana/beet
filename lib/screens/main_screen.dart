import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final List<String> plans = <String>['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          'beet',
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
              // TODO 設定画面を表示
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
          itemCount: plans.length,
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
                child: Center(child: Text('sample ${plans[index]}')),
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
        ],
      ),
    );
  }
}
