import 'package:beet/utilities/constants.dart';
import 'package:beet/models/user_setting_models/user_profile_model.dart';
import 'package:beet/screens/user_setting_screens/user_edit_name_screen.dart';
import 'package:beet/screens/welcome_screen.dart';
import 'package:beet/widgets/thin_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProfileModel>(
      create: (_) => UserProfileModel()..init(userId: userId),
      child: Consumer<UserProfileModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('アカウント情報'),
                centerTitle: true,
              ),
              body: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: kDullWhiteColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 128.0,
                                        height: 128.0,
                                        child: InkWell(
                                          child: CircleAvatar(
                                            backgroundImage: model.imageFile !=
                                                    null
                                                ? FileImage(model.imageFile)
                                                : model.userImageURL.isNotEmpty
                                                    ? NetworkImage(
                                                        model.userImageURL)
                                                    : AssetImage(
                                                        'images/test_user_image.png'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () async {
                                            ChangeImage changeImage =
                                                await _showEditIconBottomSheet(
                                                    context);
                                            if (changeImage ==
                                                ChangeImage.delete) {
                                              model.startLoading();
                                              try {
                                                await model.deleteUserImage();
                                              } catch (e) {
                                                await _showTextDialog(
                                                    context, e.toString());
                                              }
                                              model.endLoading();
                                            } else if (changeImage ==
                                                ChangeImage.select) {
                                              await model.pickImageFile();
                                              if (model.imageFile != null) {
                                                model.startLoading();
                                                try {
                                                  await model.updateUserImage();
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
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.add_a_photo,
                                              color: Colors.white,
                                              size: 20.0,
                                            ),
                                            onPressed: () async {
                                              ChangeImage changeImage =
                                                  await _showEditIconBottomSheet(
                                                      context);
                                              if (changeImage ==
                                                  ChangeImage.delete) {
                                                model.startLoading();
                                                try {
                                                  await model.deleteUserImage();
                                                } catch (e) {
                                                  await _showTextDialog(
                                                      context, e.toString());
                                                }
                                                model.endLoading();
                                              } else if (changeImage ==
                                                  ChangeImage.select) {
                                                await model.pickImageFile();
                                                if (model.imageFile != null) {
                                                  model.startLoading();
                                                  try {
                                                    await model
                                                        .updateUserImage();
                                                  } catch (e) {
                                                    await _showTextDialog(
                                                        context, e.toString());
                                                  }
                                                  model.endLoading();
                                                }
                                              }
                                            },
                                          ),
                                          backgroundColor: Colors.black45,
                                          radius: 18.0,
                                        ),
                                        bottom: 4.0,
                                        right: 4.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
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
                                      userId: userId,
                                      userName: model.userName,
                                    ),
                                  ),
                                );
                                model.init(userId: userId);
                              },
                            ),
                            Expanded(
                              child: Container(
                                color: kDullWhiteColor,
                              ),
                            ),
                            FlatButton(
                              child: Text(
                                'アカウントを削除',
                                style: kDeleteButtonTextStyle,
                              ),
                              onPressed: () async {
                                String password =
                                    await _showDeleteAccountBottomSheet(
                                        context);
                                if (password.isNotEmpty) {
                                  model.startLoading();
                                  try {
                                    await model.deleteAccount(
                                        password: password);
                                    await _showTextDialog(
                                        context, 'アカウントを削除しました');
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            WelcomeScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    await _showTextDialog(context, e);
                                  }
                                  model.endLoading();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
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
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'ライブラリから選択',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: () async {
                        changeImage = ChangeImage.select;
                        Navigator.pop(context);
                      },
                    ),
                    ThinDivider(),
                    FlatButton(
                      child: Text(
                        '写真を削除',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: () async {
                        bool isDelete =
                            await _showConfirmDialog(context, 'プロフィール画像');
                        if (isDelete == true) {
                          changeImage = ChangeImage.delete;
                        } else {
                          changeImage = ChangeImage.cancel;
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  return changeImage;
}

Future<bool> _showConfirmDialog(context, message) async {
  bool isDelete;
  isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$messageを削除しますか?'),
        actions: [
          FlatButton(
            child: Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              '削除',
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
  return isDelete;
}

Future<String> _showDeleteAccountBottomSheet(BuildContext context) async {
  String password = '';
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Color(0xFF757575),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'パスワードを入力してアカウントを削除',
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        autofocus: true,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                        ),
                        onChanged: (text) {
                          password = text;
                        },
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'アカウントを削除',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        bool isDelete =
                            await _showConfirmDialog(context, 'このアカウント');
                        if (isDelete != true) {
                          password = '';
                        }
                        Navigator.pop(context);
                      },
                    ),
                    ThinDivider(),
                    FlatButton(
                      child: Text(
                        'キャンセル',
                        style: TextStyle(
                          color: kSlightlyTransparentPrimaryColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: () {
                        password = '';
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  return password;
}

Future _showTextDialog(context, message) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
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
