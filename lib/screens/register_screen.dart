import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/welcome_model.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WelcomeModel>(
      create: (_) => WelcomeModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('アカウントを作成'),
        ),
        body: Consumer<WelcomeModel>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey[800],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'アカウント名',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 18.0),
                          ),
                          onChanged: (text) {
                            model.name = text;
                          },
                        ),
                        Divider(height: 0.5),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'メールアドレス',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 18.0),
                          ),
                          onChanged: (text) {
                            model.email = text;
                          },
                        ),
                        Divider(height: 0.5),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'パスワード',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 18.0),
                          ),
                          onChanged: (text) {
                            model.password = text;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                Container(
                  height: 56.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.grey[800],
                    highlightColor: Colors.white38,
                    child: Text(
                      '新規登録',
                      style: TextStyle(
                        color: Color(0xFFf5f5f5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await model.register();
                        await _showTextDialog(context, '登録しました');
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
