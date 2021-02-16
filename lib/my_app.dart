import 'package:beet/constants.dart';
import 'package:beet/my_app_model.dart';
import 'package:beet/screens/welcome_screen.dart';
import 'package:beet/screens/splash_screen.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:beet/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:beet/japanese_cupertino_localizations.dart';
import 'package:beet/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  final model = MyAppModel();

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
      debugShowCheckedModeBanner: false,
      title: 'beet',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
//        Colors.grey[800],
        primaryTextTheme:
            Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        scaffoldBackgroundColor: kBackGroundColor,
      ),
      home: StreamBuilder(
        stream: model.userState,
        initialData: UserState.waiting,
        builder: (context, AsyncSnapshot<UserState> snapshot) {
          final UserState state =
              snapshot.connectionState == ConnectionState.waiting
                  ? UserState.waiting
                  : snapshot.data;
          print("MyApp(): userState = $state");
          return _convertPage(state: state);
        },
      ),
    );
  }

  Widget _convertPage({UserState state}) {
    switch (state) {
      case UserState.waiting: // 初期化中
        return SplashScreen();

      case UserState.notLoggedIn: // 未ログイン
        return WelcomeScreen();

      case UserState.loggedIn: // 登録済み
        return UserScreen(userID: model.userID);

      default: // 不明
        return LoginScreen();
    }
  }
}
