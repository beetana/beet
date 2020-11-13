import 'package:beet/models/user_setting_models/user_security_model.dart';
import 'package:beet/screens/login_screen.dart';
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
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('メールアドレス'),
                        subtitle: Text(model.email),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
//                          await Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => UserUpdateScreen(
//                                userID: userID,
//                              ),
//                            ),
//                          );
//                          model.init(userID: userID);
                        },
                      ),
                    ),
                    Divider(
                      height: 0.5,
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('パスワード'),
                        subtitle: Text('********'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => UserUpdateScreen(
//                                userID: userID,
//                              ),
//                            ),
//                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.black54,
                          ),
                          Text('ログアウト'),
                        ],
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
                                    LoginScreen(),
                              ),
                            );
                          } catch (e) {
                            await _showTextDialog(context, e);
                          }
                          model.endLoading();
                        }
                      },
                    )
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
            Radius.circular(5.0),
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
            Radius.circular(5.0),
          ),
        ),
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text('ログアウト'),
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