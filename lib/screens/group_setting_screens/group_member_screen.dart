import 'package:beet/models/group_setting_models/group_member_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupMemberModel>(
      create: (_) => GroupMemberModel(),
      child: Consumer<GroupMemberModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('メンバー'),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    RaisedButton(
                        child: Text('OK'),
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await _showTextDialog(context, 'プロフィール画像を保存しました');
                            Navigator.pop(context);
                          } catch (e) {
                            await _showTextDialog(context, e.toString());
                          }
                          model.endLoading();
                        }),
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
