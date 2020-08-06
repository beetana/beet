import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beet/models/add_group_model.dart';
import 'package:beet/screens/main_screen.dart';

class AddGroupScreen extends StatelessWidget {
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddGroupModel>(
      create: (_) => AddGroupModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('グループを追加'),
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
                      child: Text('追加'),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.addGroup();
                          await _showTextDialog(context, '追加しました');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              // TODO 追加したグループのページへ遷移
                              builder: (BuildContext context) => MainScreen(),
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
