import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_edit_task_model.dart';
import 'package:beet/task.dart';
import 'package:beet/widgets/assign_task_list_tile.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEditTaskScreen extends StatelessWidget {
  UserEditTaskScreen({this.userID, this.task});
  final String userID;
  final Task task;
  final taskTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    taskTitleController.text = task.title;
    return ChangeNotifierProvider<UserEditTaskModel>(
      create: (_) => UserEditTaskModel()..init(userID: userID, task: task),
      child: Consumer<UserEditTaskModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('タスク編集'),
                  centerTitle: true,
                  actions: [
                    FlatButton(
                      child: Text(
                        '更新',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.updateTask();
                          Navigator.pop(context);
                        } catch (e) {
                          _showTextDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                  ],
                ),
                body: LayoutBuilder(builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 16.0, right: 16.0),
                                child: TextField(
                                  controller: taskTitleController,
                                  decoration: InputDecoration(
                                    hintText: 'やること',
                                  ),
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
                                title: Text(
                                  'いつまでに',
                                  style: TextStyle(
                                    color: kSlightlyTransparentPrimaryColor,
                                  ),
                                ),
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
                              Visibility(
                                visible: model.ownerID != userID,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16.0),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        'だれが',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color:
                                              kSlightlyTransparentPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Container(
                                      height: 320,
                                      child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        itemCount: model.groupMembers.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String userID = model.usersID[index];
                                          String userName =
                                              model.groupMembers[userID].name;
                                          String userImageURL = model
                                              .groupMembers[userID].imageURL;
                                          return AssignTaskListTile(
                                            userName: userName,
                                            userImageURL: userImageURL,
                                            isChecked: model.assignedMembersID
                                                .contains(userID),
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
                              Expanded(
                                child: SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
