import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_task_list_model.dart';
import 'package:beet/screens/group_screens/group_add_task_screen.dart';
import 'package:beet/screens/group_screens/group_task_details_screen.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:beet/widgets/task_list_tile.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupTaskListScreen extends StatelessWidget {
  final String groupId;
  final double textScale;

  GroupTaskListScreen({this.groupId, this.textScale});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupTaskListModel>(
      create: (_) => GroupTaskListModel()..init(groupId: groupId),
      child: Consumer<GroupTaskListModel>(builder: (context, model, child) {
        return Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemExtent: 80.0 * textScale,
                                  itemCount: model.notCompletedTasks.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index <
                                        model.notCompletedTasks.length) {
                                      final task =
                                          model.notCompletedTasks[index];
                                      return TaskListTile(
                                        task: task,
                                        users: model.members,
                                        textScale: textScale,
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
                                                  GroupTaskDetailsScreen(
                                                groupId: groupId,
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
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),
                            model.isLoading
                                ? Container(
                                    color: Colors.transparent,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : model.notCompletedTasks.isEmpty
                                    ? const Center(
                                        child: Text('未完了のタスクはありません'),
                                      )
                                    : const SizedBox(),
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemExtent: 80.0,
                                  itemCount: model.completedTasks.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index < model.completedTasks.length) {
                                      final task = model.completedTasks[index];
                                      return TaskListTile(
                                        task: task,
                                        users: model.members,
                                        textScale: textScale,
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
                                                  GroupTaskDetailsScreen(
                                                groupId: groupId,
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
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ),
                            model.isLoading
                                ? Container(
                                    color: Colors.transparent,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : model.completedTasks.isEmpty
                                    ? const Center(
                                        child: Text('完了済みのタスクはありません'),
                                      )
                                    : const SizedBox(),
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
                              GroupAddTaskScreen(groupId: groupId),
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
