import 'package:beet/models/user_setting_models/user_edit_name_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/dark_loading_indicator.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEditNameScreen extends StatelessWidget {
  final String userName;
  final TextEditingController userNameController = TextEditingController();

  UserEditNameScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    userNameController.text = userName;
    return ChangeNotifierProvider<UserEditNameModel>(
      create: (_) => UserEditNameModel()..init(userName: userName),
      child: Consumer<UserEditNameModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: SizedAppBar(
                  title: 'アカウント名を変更',
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
                          await model.updateUserName();
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
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: 'アカウント名',
                      suffix: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          userNameController.clear();
                          model.userName = '';
                        },
                      ),
                    ),
                    onChanged: (text) {
                      model.userName = text;
                    },
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
