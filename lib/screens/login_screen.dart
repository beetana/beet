import 'package:beet/screens/register_screen.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/welcome_model.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WelcomeModel>(
      create: (_) => WelcomeModel(),
      child: Scaffold(
        body: Consumer<WelcomeModel>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'メールアドレス',
                  ),
                  onChanged: (text) {
                    model.email = text;
                  },
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'パスワード',
                  ),
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                RaisedButton(
                  elevation: 3.0,
                  child: Text("ログイン"),
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () async {
                    try {
                      await model.login();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UserScreen(userID: model.userID),
                        ),
                      );
                    } catch (e) {
                      _showTextDialog(context, e);
                    }
                  },
                ),
                Expanded(
                  flex: 2,
                  child: (Container()),
                ),
                FlatButton(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "アカウントを作成",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
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
