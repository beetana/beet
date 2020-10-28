import 'package:beet/models/setting_models/group_image_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupImageUpdateScreen extends StatelessWidget {
  GroupImageUpdateScreen({this.groupID, this.groupImageURL});
  final String groupID;
  final String groupImageURL;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupImageUpdateModel>(
      create: (_) => GroupImageUpdateModel()
        ..init(groupID: groupID, groupImageURL: groupImageURL),
      child: Scaffold(
        appBar: AppBar(
          title: Text('プロフィール画像を変更'),
        ),
        body: Consumer<GroupImageUpdateModel>(builder: (context, model, child) {
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
                                  : model.groupImageURL != null
                                      //TODO NetworkImageを取得するのに時間がかかるのでインジケーターを出したい
                                      ? NetworkImage(model.groupImageURL)
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
                          await model.updateGroupImage();
                          await _showTextDialog(context, 'プロフィール画像を保存しました');
                          Navigator.pop(context);
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
