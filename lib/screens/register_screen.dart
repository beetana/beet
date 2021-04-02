import 'package:beet/constants.dart';
import 'package:beet/screens/user_screens/user_screen.dart';
import 'package:beet/screens/user_setting_screens/user_terms_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/register_model.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('アカウントを作成'),
          ),
          body: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 16.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    hintText: 'アカウント名',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 18.0),
                                  ),
                                  onChanged: (text) {
                                    model.name = text;
                                  },
                                ),
                                ThinDivider(),
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
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
                                  decoration: const InputDecoration(
                                    hintText: 'パスワード（6文字以上）',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 18.0),
                                  ),
                                  onChanged: (text) {
                                    model.password = text;
                                  },
                                ),
                                ThinDivider(),
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'パスワード（確認用）',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 18.0),
                                  ),
                                  onChanged: (text) {
                                    model.confirmPassword = text;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              activeColor: kPrimaryColor,
                              value: model.isAgree,
                              onChanged: (value) {
                                model.toggleCheckState();
                              },
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'MPLUS1p',
                                ),
                                children: [
                                  TextSpan(
                                    text: '利用規約',
                                    style: const TextStyle(
                                      color: kEnterButtonColor,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2.0,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserTermsScreen(),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(
                                    text: ' を読んで同意しました',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: model.isAgree
                                  ? kPrimaryColor
                                  : kTransparentPrimaryColor,
                              primary: Colors.white38,
                            ),
                            child: const Text(
                              '新規登録',
                              style: TextStyle(
                                color: Color(0xFFf5f5f5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: model.isAgree
                                ? () async {
                                    model.startLoading();
                                    try {
                                      await model.register();
                                      await showMessageDialog(
                                          context, '登録しました。');
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
                                  }
                                : null,
                          ),
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
    );
  }
}
