import 'package:beet/constants.dart';
import 'package:beet/models/login_model.dart';
import 'package:beet/screens/reset_password_screen.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          // キーボードを完全に閉じてから戻らないとUIが崩れることがあるので少し待つ
          await Future.delayed(
            const Duration(milliseconds: 80),
          );
          return true;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: SizedAppBar(
              title: 'ログイン',
            ),
            body: Consumer<LoginModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 32.0),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: kPrimaryColor,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'メールアドレス',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                    ),
                                    onChanged: (text) {
                                      model.email = text;
                                    },
                                  ),
                                  ThinDivider(),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: 'パスワード',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                                    ),
                                    onChanged: (text) {
                                      model.password = text;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Container(
                            height: 56.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white38,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: kPrimaryColor,
                              ),
                              child: const Text(
                                'ログイン',
                                style: TextStyle(
                                  color: Colors.white,
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
                                      builder: (BuildContext context) => UserScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  showMessageDialog(context, e.toString());
                                }
                                model.endLoading();
                              },
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          TextButton(
                            child: const Text(
                              'パスワードを忘れた場合',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kSlightlyTransparentPrimaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResetPasswordScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                  DarkLoadingIndicator(isLoading: model.isLoading),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
