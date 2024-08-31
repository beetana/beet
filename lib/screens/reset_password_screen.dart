import 'package:beet/constants.dart';
import 'package:beet/models/reset_password_model.dart';
import 'package:beet/screens/welcome_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResetPasswordModel>(
      create: (_) => ResetPasswordModel(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('パスワード再設定'),
          ),
          body: Consumer<ResetPasswordModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Container(
                          height: 56.0,
                          width: 160.0,
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
                                '送信',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                model.startLoading();
                                try {
                                  await model.sendResetEmail();
                                  await showMessageDialog(context, 'パスワード再設定用のメールを送信しました。メールに記載されているURLから再設定を行ってください。');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WelcomeScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  showMessageDialog(context, e.toString());
                                }
                                model.endLoading();
                              }),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'パスワード再設定用のURLを送信します。\n再設定したいアカウントのメールアドレスを\n入力してください。',
                          style: TextStyle(fontSize: 14.0),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
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
