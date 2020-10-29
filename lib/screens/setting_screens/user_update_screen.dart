import 'package:beet/models/setting_models/user_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserUpdateScreen extends StatelessWidget {
  UserUpdateScreen({this.userID, this.userName, this.userImageURL});
  final String userID;
  final String userName;
  final String userImageURL;
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userNameController.text = userName;
    return ChangeNotifierProvider<UserUpdateModel>(
      create: (_) => UserUpdateModel()
        ..init(
          userID: userID,
          userName: userName,
          userImageURL: userImageURL,
        ),
      child: Consumer<UserUpdateModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('ユーザー情報を変更'),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 128.0,
                      height: 128.0,
                      child: InkWell(
                        child: CircleAvatar(
                          backgroundImage: model.imageFile != null
                              ? FileImage(model.imageFile)
                              : model.userImageURL != null
                                  ? NetworkImage(model.userImageURL)
                                  : AssetImage('images/test_user_image.png'),
                          backgroundColor: Colors.transparent,
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          await model.pickImageFile();
                          if (model.imageFile != null) {
                            model.startLoading();
                            try {
                              await model.updateUserImage();
                              await _showTextDialog(context, 'プロフィール画像を保存しました');
                              Navigator.pop(context);
                            } catch (e) {
                              await _showTextDialog(context, e.toString());
                            }
                            model.endLoading();
                          }
                        },
                      ),
                    ),
                    TextField(
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
