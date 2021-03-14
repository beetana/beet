import 'package:beet/utilities/constants.dart';
import 'package:beet/models/group_setting_models/group_profile_model.dart';
import 'package:beet/screens/group_setting_screens/group_edit_name_screen.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupProfileScreen extends StatelessWidget {
  GroupProfileScreen({this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupProfileModel>(
      create: (_) => GroupProfileModel()..init(groupId: groupId),
      child: Consumer<GroupProfileModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('グループ情報'),
                centerTitle: true,
              ),
              body: Column(
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
                                  backgroundImage: model.imageFile != null
                                      ? FileImage(model.imageFile)
                                      : model.groupImageURL.isNotEmpty
                                          ? NetworkImage(model.groupImageURL)
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
                                      await model.deleteGroupImage();
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
                                        await model.updateGroupImage();
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
                                        await _showEditIconBottomSheet(context);
                                    if (changeImage == ChangeImage.delete) {
                                      model.startLoading();
                                      try {
                                        await model.deleteGroupImage();
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
                                          await model.updateGroupImage();
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
                    title: Text('グループ名'),
                    subtitle: Text(
                      model.groupName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupEditNameScreen(
                            groupId: groupId,
                            groupName: model.groupName,
                          ),
                        ),
                      );
                      model.init(groupId: groupId);
                    },
                  ),
                  Expanded(
                    child: Container(
                      color: kDullWhiteColor,
                    ),
                  ),
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
                    BasicDivider(),
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
        title: Text('プロフィール画像を削除しますか?'),
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
