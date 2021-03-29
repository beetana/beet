import 'package:beet/constants.dart';
import 'package:beet/models/user_models/user_task_list_model.dart';
import 'package:beet/screens/user_screens/user_add_task_screen.dart';
import 'package:beet/screens/user_screens/user_task_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:beet/widgets/task_list_tile.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTaskListScreen extends StatelessWidget {
  UserTaskListScreen({this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserTaskListModel>(
      create: (_) => UserTaskListModel()..init(userId: userId),
      child: Consumer<UserTaskListModel>(builder: (context, model, child) {
        return Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 32.0,
                      indicatorColor: kPrimaryColor,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: [
                      Tab(
                        child: Text(
                          '未完了',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '完了',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Stack(
                          children: [
                            Scrollbar(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  try {
                                    await model.getTaskList();
                                  } catch (e) {
                                    showMessageDialog(context, e.toString());
                                  }
                                },
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemExtent: 80.0,
                                  itemCount: model.notCompletedTasks.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index <
                                        model.notCompletedTasks.length) {
                                      final task =
                                          model.notCompletedTasks[index];
                                      return TaskListTile(
                                        task: task,
                                        users: model.joiningGroupUsers,
                                        checkboxCallback: (value) {
                                          model.toggleCheckState(task: task);
                                        },
                                        longPressedCallBack: () async {
                                          bool isDelete =
                                              await _confirmDeleteDialog(
                                                  context, 'このタスクを削除しますか？');
                                          if (isDelete == true) {
                                            model.startLoading();
                                            try {
                                              await model.deleteTask(
                                                  task: task);
                                            } catch (e) {
                                              showMessageDialog(
                                                  context, e.toString());
                                            }
                                            model.endLoading();
                                          }
                                        },
                                        tileTappedCallback: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserTaskDetailsScreen(
                                                userId: userId,
                                                task: task,
                                              ),
                                            ),
                                          );
                                          try {
                                            await model.getTaskList();
                                          } catch (e) {
                                            showMessageDialog(
                                                context, e.toString());
                                          }
                                        },
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),
                            model.isLoading
                                ? Container(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : model.notCompletedTasks.isEmpty
                                    ? Center(
                                        child: Text('未完了のタスクはありません'),
                                      )
                                    : SizedBox(),
                          ],
                        ),
                        Stack(
                          children: [
                            Scrollbar(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  try {
                                    await model.getTaskList();
                                  } catch (e) {
                                    showMessageDialog(context, e.toString());
                                  }
                                },
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemExtent: 80.0,
                                  itemCount: model.completedTasks.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < model.completedTasks.length) {
                                      final task = model.completedTasks[index];
                                      return TaskListTile(
                                        task: task,
                                        users: model.joiningGroupUsers,
                                        checkboxCallback: (value) {
                                          model.toggleCheckState(task: task);
                                        },
                                        longPressedCallBack: () async {
                                          bool isDelete =
                                              await _confirmDeleteDialog(
                                                  context, 'このタスクを削除しますか？');
                                          if (isDelete == true) {
                                            model.startLoading();
                                            try {
                                              await model.deleteTask(
                                                  task: task);
                                            } catch (e) {
                                              showMessageDialog(
                                                  context, e.toString());
                                            }
                                            model.endLoading();
                                          }
                                        },
                                        tileTappedCallback: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserTaskDetailsScreen(
                                                userId: userId,
                                                task: task,
                                              ),
                                            ),
                                          );
                                          try {
                                            await model.getTaskList();
                                          } catch (e) {
                                            showMessageDialog(
                                                context, e.toString());
                                          }
                                        },
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),
                            model.isLoading
                                ? Container(
                                    color: Colors.transparent,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : model.completedTasks.isEmpty
                                    ? Center(
                                        child: Text('完了済みのタスクはありません'),
                                      )
                                    : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                      onPressed: model.changeStateTasks.isEmpty
                          ? null
                          : () async {
                              model.startLoading();
                              try {
                                await model.updateCheckState();
                                await model.getTaskList();
                              } catch (e) {
                                showMessageDialog(context, e.toString());
                              }
                              model.endLoading();
                            },
                      child: Text(
                        '更新',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: model.changeStateTasks.isEmpty
                              ? kInvalidEnterButtonColor
                              : kEnterButtonColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AddFloatingActionButton(
              onPressed: model.isLoading
                  ? null
                  : () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserAddTaskScreen(userId: userId),
                          fullscreenDialog: true,
                        ),
                      );
                      try {
                        await model.getTaskList();
                      } catch (e) {
                        showMessageDialog(context, e.toString());
                      }
                    },
            ),
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
