import 'package:beet/screens/group_screens/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/add_group_model.dart';

class AddGroupScreen extends StatelessWidget {
  AddGroupScreen({this.userName});
  final String userName;
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddGroupModel>(
      create: (_) => AddGroupModel()..init(userName),
      child: Scaffold(
        appBar: AppBar(
          title: Text('グループを作成'),
        ),
        body: Consumer<AddGroupModel>(builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: groupNameController,
                      decoration: InputDecoration(hintText: 'グループ名'),
                      onChanged: (text) {
                        model.groupName = text;
                      },
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    RaisedButton(
                      child: Text('作成'),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.addGroup();
                          await _showTextDialog(context, '追加しました');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => GroupScreen(
                                groupID: model.groupID,
                              ),
                            ),
                          );
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
