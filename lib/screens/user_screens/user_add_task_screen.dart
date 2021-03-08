import 'package:beet/models/user_models/user_add_task_model.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddTaskScreen extends StatelessWidget {
  UserAddTaskScreen({this.userID});
  final String userID;
  final taskTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserAddTaskModel>(
      create: (_) => UserAddTaskModel()..init(userID: userID),
      child: Consumer<UserAddTaskModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('タスクを追加'),
                  centerTitle: true,
                  actions: [
                    FlatButton(
                      child: Text(
                        '追加',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.addTask();
                          Navigator.pop(context);
                        } catch (e) {
                          _showTextDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                        child: TextField(
                          controller: taskTitleController,
                          decoration: InputDecoration(hintText: 'やること'),
                          onTap: () {
                            if (model.isShowDueDatePicker == true) {
                              model.showDueDatePicker();
                            }
                          },
                          onChanged: (text) {
                            model.taskTitle = text;
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('いつまでに'),
                        trailing: Text(model.dueDateText),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          model.showDueDatePicker();
                        },
                      ),
                      model.dueDatePickerBox,
                      BasicDivider(
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                    ],
                  ),
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
