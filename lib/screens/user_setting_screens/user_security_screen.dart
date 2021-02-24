import 'package:beet/constants.dart';
import 'package:beet/models/user_setting_models/user_security_model.dart';
import 'package:beet/screens/welcome_screen.dart';
import 'package:beet/screens/user_setting_screens/user_update_email_screen.dart';
import 'package:beet/screens/user_setting_screens/user_update_password_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSecurityScreen extends StatelessWidget {
  UserSecurityScreen({this.userID});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserSecurityModel>(
      create: (_) => UserSecurityModel()..init(userID: userID),
      child: Consumer<UserSecurityModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('ログインとセキュリティ'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('メールアドレス'),
                        subtitle: Text(model.email),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserUpdateEmailScreen(
                                email: model.email,
                              ),
                            ),
                          );
                          model.init(userID: userID);
                        },
                      ),
                    ),
                    ThinDivider(
                      indent: 16.0,
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('パスワード'),
                        subtitle: Text('********'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserUpdatePasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: kDullWhiteColor,
                      ),
                    ),
                    FlatButton.icon(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.black54,
                      ),
                      label: Text(
                        'ログアウト',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onPressed: () async {
                        bool isLogout =
                            await _confirmLogoutDialog(context, 'ログアウトしますか？');
                        if (isLogout == true) {
                          model.startLoading();
                          try {
                            await model.logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    WelcomeScreen(),
                              ),
                            );
                          } catch (e) {
                            await _showTextDialog(context, e);
                          }
                          model.endLoading();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            model.isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }
}

Future _showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future _confirmLogoutDialog(context, message) async {
  bool _isLogout;
  _isLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              'ログアウト',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return _isLogout;
}
