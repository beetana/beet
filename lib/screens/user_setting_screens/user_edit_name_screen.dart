import 'package:beet/models/user_setting_models/user_edit_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEditNameScreen extends StatelessWidget {
  UserEditNameScreen({this.userID, this.userName});
  final String userID;
  final String userName;
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userNameController.text = userName;
    return ChangeNotifierProvider<UserEditNameModel>(
      create: (_) =>
          UserEditNameModel()..init(userID: userID, userName: userName),
      child: Consumer<UserEditNameModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('アカウント名を変更'),
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
                        await model.updateUserName();
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
                child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: 'アカウント名',
                    suffix: IconButton(
                      icon: Icon(
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
