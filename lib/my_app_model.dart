import 'dart:async';

import 'package:beet/objects/user.dart';
import 'package:beet/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_core/firebase_core.dart';

class MyAppModel {
  String userId;

  // ignore: close_sinks
  final _userStateStreamController = StreamController<UserState>();
  Stream<UserState> get userState => _userStateStreamController.stream;

  UserState _state;

  MyAppModel() {
    _init(); // 初期化処理は非同期で行うためawaitしない
  }

  Future _init() async {
    // packageの初期化処理
    await Firebase.initializeApp();

    // ログイン状態の変化を監視し、変更があればUserStateをstreamで通知する
    Auth.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      UserState state = UserState.notLoggedIn;
      final user = await _fetchUser(firebaseUser);
      if (user != null) {
        state = UserState.loggedIn;
      } else {
        state = UserState.notLoggedIn;
      }

      // 前回と同じ通知はしない
      if (_state == state) {
        return;
      }
      _state = state;

      // notLoggedInの場合すぐにSplashPageが閉じてしまうので少し待つ
      if (_state == UserState.notLoggedIn) {
        await Future.delayed(Duration(seconds: 3));
      }

      _userStateStreamController.sink.add(_state);
    });
  }

  Future<User> _fetchUser(Auth.User firebaseUser) async {
    if (firebaseUser == null) {
      return null;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    if (!doc.exists) {
      return null;
    }
    User user = User.doc(doc);
    userId = user.id;
    return user;
  }
}
