import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:beet/my_app.dart';

Future main() async {
  // main内で非同期処理を呼び出す場合runApp前に初期化が必要
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
