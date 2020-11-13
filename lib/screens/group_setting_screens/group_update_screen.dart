import 'package:beet/models/group_setting_models/group_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupUpdateScreen extends StatelessWidget {
  GroupUpdateScreen({this.groupID, this.groupName, this.groupImageURL});
  final String groupID;
  final String groupName;
  final String groupImageURL;
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    groupNameController.text = groupName;
    return ChangeNotifierProvider<GroupUpdateModel>(
      create: (_) => GroupUpdateModel()
        ..init(
          groupID: groupID,
          groupName: groupName,
          groupImageURL: groupImageURL,
        ),
      child: Consumer<GroupUpdateModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('グループ情報を編集'),
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
                              : model.groupImageURL != null
                                  ? NetworkImage(model.groupImageURL)
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
                              await model.updateGroupImage();
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
                      controller: groupNameController,
                      decoration: InputDecoration(
                        hintText: 'グループ名',
                        suffix: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            groupNameController.clear();
                            model.groupName = '';
                          },
                        ),
                      ),
                      onChanged: (text) {
                        model.groupName = text;
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
                          await model.updateGroupName();
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
