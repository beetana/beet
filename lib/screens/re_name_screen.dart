import 'package:beet/models/re_name_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReNameScreen extends StatelessWidget {
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReNameModel>(
      create: (_) => ReNameModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('アカウント名を変更'),
        ),
        body: Consumer<ReNameModel>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(hintText: 'アカウント名'),
                  onChanged: (text) {
                    model.newName = text;
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () async {
                    try {
                      await model.reName();
                      await _showTextDialog(context, '変更しました');
                      Navigator.pop(context);
                    } catch (e) {
                      _showTextDialog(context, e.toString());
                    }
                  },
                )
              ],
            ),
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
