import 'package:flutter/material.dart';
import 'package:beet/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'beet',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Color(0xFFf5f5f5),
      ),
      home: WelcomeScreen(),
    );
  }
}
