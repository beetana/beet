import 'package:beet/models/setting_models/user_image_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserImageUpdateScreen extends StatelessWidget {
  UserImageUpdateScreen({this.userID, this.userImageURL});
  final String userID;
  final String userImageURL;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserImageUpdateModel>(
      create: (_) => UserImageUpdateModel()
        ..init(userID: userID, userImageURL: userImageURL),
      child: Scaffold(
        appBar: AppBar(
          title: Text('プロフィール画像を変更'),
        ),
        body: Consumer<UserImageUpdateModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: SizedBox(
                          width: 128.0,
                          height: 128.0,
                          child: InkWell(
                            child: CircleAvatar(
                              backgroundImage: model.imageFile != null
                                  ? FileImage(model.imageFile)
                                  : model.userImageURL != null
                                      ? NetworkImage(model.userImageURL)
                                      : AssetImage(
                                          'images/test_user_image.png'),
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: () async {
                              await model.pickImageFile();
                            },
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(onPressed: () async {
                      if (model.imageFile != null) {
                        model.startLoading();
                        try {
                          await model.updateUserImage();
                          await _showTextDialog(context, 'プロフィール画像を保存しました');
                        } catch (e) {
                          await _showTextDialog(context, e.toString());
                        }
                        model.endLoading();
                      }
                    })
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
