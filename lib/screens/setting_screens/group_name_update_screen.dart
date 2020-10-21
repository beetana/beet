import 'package:beet/models/setting_models/group_name_update_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupNameUpdateScreen extends StatelessWidget {
  GroupNameUpdateScreen({this.groupID, this.groupName});
  final String groupID;
  final String groupName;
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    groupNameController.text = groupName;
    return ChangeNotifierProvider<GroupNameUpdateModel>(
      create: (_) =>
          GroupNameUpdateModel()..init(groupID: groupID, groupName: groupName),
      child: Scaffold(
        appBar: AppBar(
          title: Text('グループ名を変更'),
        ),
        body: Consumer<GroupNameUpdateModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: groupNameController,
                      autofocus: true,
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
                          _showTextDialog(context, e.toString());
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
                  : SizedBox()
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
