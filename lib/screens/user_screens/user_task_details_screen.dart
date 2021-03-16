import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_task_details_model.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/screens/user_screens/user_edit_task_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserTaskDetailsScreen extends StatelessWidget {
  UserTaskDetailsScreen({this.userId, this.task});
  final String userId;
  final Task task;
  final dueDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserTaskDetailsModel>(
      create: (_) => UserTaskDetailsModel()..init(userId: userId, task: task),
      child: Consumer<UserTaskDetailsModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('タスク'),
                centerTitle: true,
                actions: [
                  TextButton(
                    child: Text(
                      '編集',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserEditTaskScreen(
                            userId: userId,
                            task: model.task,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      model.startLoading();
                      try {
                        await model.getTask();
                      } catch (e) {
                        showMessageDialog(context, e.toString());
                      }
                      model.endLoading();
                    },
                  ),
                ],
              ),
              body: model.owner != null
                  ? SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Container(
                                      width: 32.0,
                                      height: 32.0,
                                      child: CircleAvatar(
                                        backgroundImage: model.owner.imageURL ==
                                                null
                                            ? AssetImage(
                                                'images/test_user_image.png')
                                            : model.owner.imageURL.isNotEmpty
                                                ? NetworkImage(
                                                    model.owner.imageURL)
                                                : AssetImage(
                                                    'images/test_user_image.png'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(model.owner.name),
                                  ],
                                ),
                                SizedBox(height: 8.0),
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
                                Container(
                                  height: 72.0,
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: ScrollPhysics(),
                                      itemExtent: 60.0,
                                      itemCount: model.assignedMembersId.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String imageURL = model
                                            .groupMembers[
                                                model.assignedMembersId[index]]
                                            .imageURL;
                                        String name = model
                                            .groupMembers[
                                                model.assignedMembersId[index]]
                                            .name;
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 40.0,
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
                                              SizedBox(height: 2.0),
                                              Text(
                                                name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 9.0),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Text('メモ'),
                                SizedBox(height: 4.0),
                                BasicDivider(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(model.taskMemo),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BasicDivider(
                            indent: 16.0,
                            endIndent: 16.0,
                          ),
                          SizedBox(height: 8.0),
                          Center(
                            child: TextButton(
                              child: Text(
                                '削除',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                              onPressed: () async {
                                bool isDelete = await _confirmDeleteDialog(
                                    context, 'このタスクを削除しますか？');
                                if (isDelete == true) {
                                  model.startLoading();
                                  try {
                                    await model.deleteTask();
                                    Navigator.pop(context);
                                  } catch (e) {
                                    showMessageDialog(context, e.toString());
                                  }
                                  model.endLoading();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
            model.isLoading
                ? Container(
//                      color: Colors.black.withOpacity(0.3),
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

Future _confirmDeleteDialog(context, message) async {
  bool _isDelete;
  _isDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
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
