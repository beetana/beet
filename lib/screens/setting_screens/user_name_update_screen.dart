import 'package:beet/models/setting_models/user_name_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNameUpdateScreen extends StatelessWidget {
  UserNameUpdateScreen({this.userID, this.userName});
  final String userID;
  final String userName;
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userNameController.text = userName;
    return ChangeNotifierProvider<UserNameUpdateModel>(
      create: (_) =>
          UserNameUpdateModel()..init(userID: userID, userName: userName),
      child: Scaffold(
        appBar: AppBar(
          title: Text('アカウント名を変更'),
        ),
        body: Consumer<UserNameUpdateModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: userNameController,
                      autofocus: true,
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
                    SizedBox(
                      height: 24.0,
                    ),
                    RaisedButton(
                      child: Text('OK'),
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
