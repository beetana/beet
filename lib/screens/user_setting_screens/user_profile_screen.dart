import 'package:beet/models/user_setting_models/user_profile_model.dart';
import 'package:beet/screens/user_setting_screens/user_edit_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({this.userID});
  final String userID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProfileModel>(
      create: (_) => UserProfileModel()..init(userID: userID),
      child: Consumer<UserProfileModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('アカウント情報'),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 128.0,
                          height: 128.0,
                          child: InkWell(
                            child: CircleAvatar(
                              backgroundImage: model.imageFile != null
                                  ? FileImage(model.imageFile)
                                  : model.userImageURL.isNotEmpty
                                      ? NetworkImage(model.userImageURL)
                                      : AssetImage(
                                          'images/test_user_image.png'),
                              backgroundColor: Colors.transparent,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              ChangeImage changeImage =
                                  await _showEditIconBottomSheet(context);
                              if (changeImage == ChangeImage.delete) {
                                model.startLoading();
                                try {
                                  await model.deleteUserImage();
                                  await _showTextDialog(context, '削除しました');
                                } catch (e) {
                                  await _showTextDialog(context, e.toString());
                                }
                                model.endLoading();
                              } else if (changeImage == ChangeImage.select) {
                                await model.pickImageFile();
                                if (model.imageFile != null) {
                                  model.startLoading();
                                  try {
                                    await model.updateUserImage();
                                    await _showTextDialog(
                                        context, 'プロフィール画像を保存しました');
                                  } catch (e) {
                                    await _showTextDialog(
                                        context, e.toString());
                                  }
                                  model.endLoading();
                                }
                              }
                            },
                          ),
                        ),
                        Positioned(
                          child: CircleAvatar(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            backgroundColor: Colors.black45,
                            radius: 18.0,
                          ),
                          bottom: 4.0,
                          right: 4.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text('アカウント名'),
                        subtitle: Text(
                          model.userName,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserEditNameScreen(
                                userID: userID,
                                userName: model.userName,
                              ),
                            ),
                          );
                          model.init(userID: userID);
                        },
                      ),
                    ),
                    Divider(height: 0.5),
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

enum ChangeImage {
  select,

  delete,

  cancel,
}

Future<ChangeImage> _showEditIconBottomSheet(BuildContext context) async {
  ChangeImage changeImage;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Color(0xff757575),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'ライブラリから選択',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: () async {
                      changeImage = ChangeImage.select;
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 0.5),
                  FlatButton(
                    child: Text(
                      '写真を削除',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: () async {
                      bool isDelete = await _showConfirmDialog(context);
                      isDelete
                          ? changeImage = ChangeImage.delete
                          : changeImage = ChangeImage.cancel;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return changeImage;
}

Future<bool> _showConfirmDialog(context) async {
  bool isDelete;
  isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        title: Text('プロフィール画像を削除しますか?'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: TextStyle(color: Colors.black54),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              '削除',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return isDelete;
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
