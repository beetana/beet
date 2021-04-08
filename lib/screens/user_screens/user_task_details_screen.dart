import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_task_details_model.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/screens/user_screens/user_edit_task_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserTaskDetailsScreen extends StatelessWidget {
  final Task task;
  final dueDateFormat = DateFormat('y/M/d(E)', 'ja_JP');

  UserTaskDetailsScreen({this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserTaskDetailsModel>(
      create: (_) => UserTaskDetailsModel()..init(task: task),
      child: Consumer<UserTaskDetailsModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('タスクの詳細'),
                actions: [
                  TextButton(
                    child: const Text(
                      '編集',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserEditTaskScreen(task: model.task),
                          fullscreenDialog: true,
                        ),
                      );
                      model.startLoading();
                      try {
                        await model.fetchTask();
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Container(
                                      width: 32.0,
                                      height: 32.0,
                                      child: CircleAvatar(
                                        backgroundImage: model.owner.imageURL ==
                                                null
                                            ? model.isOwn
                                                ? const AssetImage(
                                                    'images/user_profile.png')
                                                : const AssetImage(
                                                    'images/group_profile.png')
                                            : model.owner.imageURL.isNotEmpty
                                                ? NetworkImage(
                                                    model.owner.imageURL)
                                                : model.isOwn
                                                    ? const AssetImage(
                                                        'images/user_profile.png')
                                                    : const AssetImage(
                                                        'images/group_profile.png'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(model.owner.name),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  model.taskTitle,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                model.isDecidedDueDate
                                    ? Text(
                                        '期限  ${dueDateFormat.format(model.dueDate)}')
                                    : const Text('期限なし'),
                                Container(
                                  height: 72.0,
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: const ScrollPhysics(),
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
                                          padding: const EdgeInsets.symmetric(
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
                                                      ? const AssetImage(
                                                          'images/user_profile.png')
                                                      : imageURL.isNotEmpty
                                                          ? NetworkImage(
                                                              imageURL)
                                                          : const AssetImage(
                                                              'images/user_profile.png'),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(
                                                name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 9.0),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const Text('メモ'),
                                const SizedBox(height: 4.0),
                                BasicDivider(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                          Center(
                            child: TextButton(
                              child: const Text(
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
                  : const SizedBox(),
            ),
            LoadingIndicator(isLoading: model.isLoading),
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
            child: const Text(
              'キャンセル',
              style: kCancelButtonTextStyle,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text(
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
