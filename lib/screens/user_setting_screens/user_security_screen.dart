import 'package:beet/constants.dart';
import 'package:beet/models/user_setting_models/user_security_model.dart';
import 'package:beet/screens/welcome_screen.dart';
import 'package:beet/screens/user_setting_screens/user_update_email_screen.dart';
import 'package:beet/screens/user_setting_screens/user_update_password_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserSecurityModel>(
      create: (_) => UserSecurityModel()..init(),
      child: Consumer<UserSecurityModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('ログインとセキュリティ'),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: const Text('メールアドレス'),
                        subtitle: Text(model.email),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserUpdateEmailScreen(
                                email: model.email,
                              ),
                            ),
                          );
                          model.init();
                        },
                      ),
                    ),
                    ThinDivider(indent: 16.0),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: const Text('パスワード'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
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
                    TextButton.icon(
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: kSlightlyTransparentPrimaryColor,
                      ),
                      label: const Text(
                        'ログアウト',
                        style: TextStyle(
                          color: kSlightlyTransparentPrimaryColor,
                        ),
                      ),
                      onPressed: () async {
                        bool isLogout =
                            await _confirmLogoutDialog(context, 'ログアウトしますか？');
                        if (isLogout) {
                          model.startLoading();
                          try {
                            await model.logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => WelcomeScreen(),
                              ),
                            );
                          } catch (e) {
                            await showMessageDialog(context, e.toString());
                          }
                          model.endLoading();
                        }
                      },
                    ),
                  ],
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

Future _confirmLogoutDialog(context, message) async {
  bool _isLogout;
  _isLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
              'ログアウト',
              style: kDeleteButtonTextStyle,
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
