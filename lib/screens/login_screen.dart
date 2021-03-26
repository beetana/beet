import 'package:beet/constants.dart';
import 'package:beet/models/login_model.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('ログイン'),
          ),
          body: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                  child: SingleChildScrollView(
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
                                ThinDivider(),
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
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: kPrimaryColor,
                              primary: Colors.white38,
                            ),
                            child: Text(
                              'ログイン',
                              style: TextStyle(
                                color: Color(0xFFf5f5f5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              model.startLoading();
                              try {
                                await model.login();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserScreen(userId: model.userId),
                                  ),
                                );
                              } catch (e) {
                                showMessageDialog(context, e.toString());
                              }
                              model.endLoading();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
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
        ),
      ),
    );
  }
}
