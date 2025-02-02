import 'package:beet/models/user_setting_models/user_update_password_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserUpdatePasswordScreen extends StatelessWidget {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserUpdatePasswordModel>(
      create: (_) => UserUpdatePasswordModel(),
      child: Consumer<UserUpdatePasswordModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: SizedAppBar(
                  title: 'パスワードを変更',
                  actions: [
                    TextButton(
                      child: const Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.updatePassword();
                          await showMessageDialog(context, '変更しました。');
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
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: currentPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '現在のパスワード',
                            suffix: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                currentPasswordController.clear();
                                model.currentPassword = '';
                              },
                            ),
                          ),
                          onChanged: (text) {
                            model.currentPassword = text;
                          },
                        ),
                        TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '新しいパスワード',
                            hintText: '6文字以上',
                            suffix: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                newPasswordController.clear();
                                model.newPassword = '';
                              },
                            ),
                          ),
                          onChanged: (text) {
                            model.newPassword = text;
                          },
                        ),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '新しいパスワード(確認用)',
                            suffix: IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                confirmPasswordController.clear();
                                model.confirmNewPassword = '';
                              },
                            ),
                          ),
                          onChanged: (text) {
                            model.confirmNewPassword = text;
                          },
                        ),
                      ],
                    ),
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
