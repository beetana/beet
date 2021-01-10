import 'package:beet/models/user_setting_models/user_update_password_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserUpdatePasswordScreen extends StatelessWidget {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserUpdatePasswordModel>(
      create: (_) => UserUpdatePasswordModel(),
      child:
          Consumer<UserUpdatePasswordModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('パスワードを変更'),
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
                        await model.updatePassword();
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: currentPasswordController,
                      autofocus: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '現在のパスワード',
                        suffix: IconButton(
                          icon: Icon(
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
                          icon: Icon(
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
                      controller: confirmNewPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '新しいパスワード(確認用)',
                        suffix: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            confirmNewPasswordController.clear();
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
