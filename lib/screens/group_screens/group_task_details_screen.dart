import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_task_details_model.dart';
import 'package:beet/screens/group_screens/group_edit_task_screen.dart';
import 'package:beet/task.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupTaskDetailsScreen extends StatelessWidget {
  GroupTaskDetailsScreen({this.groupID, this.task});
  final String groupID;
  final Task task;
  final dueDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupTaskDetailsModel>(
      create: (_) =>
          GroupTaskDetailsModel()..init(groupID: groupID, task: task),
      child: Consumer<GroupTaskDetailsModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('タスク'),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '編集',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupEditTaskScreen(
                        groupID: groupID,
                        task: model.task,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                  model.startLoading();
                  try {
                    await model.getTask(task: task);
                  } catch (e) {
                    _showTextDialog(context, e.toString());
                  }
                  model.endLoading();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              model.groupMembers.isNotEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: LayoutBuilder(builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      model.taskTitle,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    model.isDecidedDueDate
                                        ? Text(
                                            '期限  ${dueDateFormat.format(model.dueDate)}')
                                        : Text('期限なし'),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    BasicDivider(),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Container(
                                      height: 300,
                                      child: ListView.builder(
                                        physics: ScrollPhysics(),
                                        itemExtent: 40.0,
                                        itemCount:
                                            model.assignedMembersID.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String imageURL = model
                                              .groupMembers[model
                                                  .assignedMembersID[index]]
                                              .imageURL;
                                          String name = model
                                              .groupMembers[model
                                                  .assignedMembersID[index]]
                                              .name;
                                          return Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 32.0,
                                                  height: 32.0,
                                                  child: CircleAvatar(
                                                    backgroundImage: imageURL ==
                                                            null
                                                        ? AssetImage(
                                                            'images/test_user_image.png')
                                                        : imageURL.isNotEmpty
                                                            ? NetworkImage(
                                                                imageURL)
                                                            : AssetImage(
                                                                'images/test_user_image.png'),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  name,
                                                  style: TextStyle(
//                                            fontSize: 18.0,
//                                                    fontWeight: FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Center(
                                      child: FlatButton(
                                        child: Text(
                                          '削除',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool isDelete =
                                              await _confirmDeleteDialog(
                                                  context, 'このタスクを削除しますか？');
                                          if (isDelete == true) {
                                            model.startLoading();
                                            try {
                                              await model.deleteTask();
                                              Navigator.pop(context);
                                            } catch (e) {
                                              _showTextDialog(
                                                  context, e.toString());
                                            }
                                            model.endLoading();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  : SizedBox(),
              model.isLoading
                  ? Container(
//                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
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

Future _confirmDeleteDialog(context, message) async {
  bool _isDelete;
  _isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text(
              '削除',
              style: kDeleteButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
  return _isDelete;
}