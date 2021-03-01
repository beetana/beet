import 'package:beet/models/group_models/group_add_task_model.dart';
import 'package:beet/widgets/assign_task_list_tile.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupAddTaskScreen extends StatelessWidget {
  GroupAddTaskScreen({this.groupID});
  final String groupID;
  final taskTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAddTaskModel>(
      create: (_) => GroupAddTaskModel()..init(groupID: groupID),
      child: Consumer<GroupAddTaskModel>(builder: (context, model, child) {
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
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        '追加',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
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
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'だれが',
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        height: 300,
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          itemCount: model.userNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            String userID = model.userIDs[index];
                            String userName = model.userNames[index];
                            String userImageURL = model.userImageURLs[index];
                            return AssignTaskListTile(
                              userName: userName,
                              userImageURL: userImageURL,
                              isChecked:
                                  model.assignedMembersID.contains(userID),
                              checkboxCallback: (state) {
                                model.assignPerson(userID);
                              },
                              tileTappedCallback: () {
                                model.assignPerson(userID);
                              },
                            );
                          },
                        ),
                      ),
                      BasicDivider(),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
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
