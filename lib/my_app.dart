import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:beet/japanese_cupertino_localizations.dart';
import 'package:beet/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        JapaneseCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ja', 'JA'),
      ],
      locale: Locale('ja', 'JA'),
      title: 'beet',
      theme: ThemeData(
        primaryColor: Colors.grey[800],
        primaryTextTheme:
            Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        scaffoldBackgroundColor: Color(0xFFf5f5f5),
      ),
      home: LoginScreen(),
//      Scaffold(
//        body: Center(
//          child: CircularProgressIndicator(),
//        ),
//      ),
    );
  }
}
