import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          child: Image.asset('images/app_icon.png'),
        ),
      ),
    );
  }
}
