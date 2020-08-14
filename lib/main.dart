import 'package:flutter/material.dart';
import 'package:beet/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'beet',
      theme: ThemeData(
        primaryColor: Colors.grey,
        accentColor: Colors.teal,
        primaryTextTheme:
            Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        scaffoldBackgroundColor: Color(0xFFf5f5f5),
      ),
      home: LoginScreen(),
    );
  }
}
