import 'package:beet/models/user_setting_models/user_update_email_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserUpdateEmailScreen extends StatelessWidget {
  UserUpdateEmailScreen({this.email});
  final email;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = email;
    return ChangeNotifierProvider<UserUpdateEmailModel>(
      create: (_) => UserUpdateEmailModel()..init(email: email),
      child: Consumer<UserUpdateEmailModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('メールアドレスを変更'),
                  actions: [
                    TextButton(
                      child: Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.updateEmail();
                          Navigator.pop(context);
                        } catch (e) {
                          await showMessageDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    )
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(16.0),
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
            ),
            DarkLoadingIndicator(isLoading: model.isLoading),
          ],
        );
      }),
    );
  }
}
