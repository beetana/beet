import 'package:beet/utilities/constants.dart';
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
        fontFamily: 'MPLUS1p',
        primaryColor: kPrimaryColor,
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              fontFamily: 'MPLUS1p',
              bodyColor: Colors.white,
            ),
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'MPLUS1p',
            fontWeight: FontWeight.normal,
          ),
        ),
        accentColor: kTransparentPrimaryColor,
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
