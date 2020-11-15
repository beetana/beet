import 'package:beet/models/user_setting_models/user_update_email_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserUpdateEmailScreen extends StatelessWidget {
  UserUpdateEmailScreen({this.userID, this.email});
  final userID;
  final email;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = email;
    return ChangeNotifierProvider<UserUpdateEmailModel>(
      create: (_) => UserUpdateEmailModel()..init(userID: userID, email: email),
      child: Consumer<UserUpdateEmailModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('メールアドレスを変更'),
                actions: [
                  FlatButton(
                    child: Text(
                      '保存',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () async {
                      model.startLoading();
                      try {
                        await model.updateEmail();
                        await _showTextDialog(context, '変更しました');
                        Navigator.pop(context);
                      } catch (e) {
                        await _showTextDialog(context, e.toString());
                      }
                      model.endLoading();
                    },
                  )
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'メールアドレス',
                        suffix: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            emailController.clear();
                            model.email = '';
                          },
                        ),
                      ),
                      onChanged: (text) {
                        model.email = text;
                      },
                    ),
                    Visibility(
                      visible: model.isAuthRequired,
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                          suffix: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              passwordController.clear();
                              model.password = '';
                            },
                          ),
                        ),
                        onChanged: (text) {
                          model.password = text;
                        },
                      ),
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
