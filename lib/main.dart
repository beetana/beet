import 'package:flutter/material.dart';
import 'package:beet/my_app.dart';
import 'package:flutter/services.dart';

void main() {
  // main内で非同期処理を呼び出す場合runApp前に初期化が必要
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //端末の向きに関係なく縦画面に固定
  ]);
  runApp(MyApp());
}

// Firebase AppCheck用
// Future<void> main() async {
//   // main内で非同期処理を呼び出す場合runApp前に初期化が必要
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp();
//   await FirebaseAppCheck.instance.activate(
//     appleProvider: kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug,
//     androidProvider: kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
//   );

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp, //端末の向きに関係なく縦画面に固定
//   ]);
//   runApp(MyApp());
// }
