import 'package:beet/constants.dart';
import 'package:beet/models/group_models/group_task_model.dart';
import 'package:beet/screens/group_screens/group_add_task_screen.dart';
import 'package:beet/screens/group_screens/group_edit_task_screen.dart';
import 'package:beet/widgets/add_floating_action_button.dart';
import 'package:beet/widgets/group_task_list_tile.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupTaskScreen extends StatelessWidget {
  GroupTaskScreen({this.groupID});
  final String groupID;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupTaskModel>(
      create: (_) => GroupTaskModel()..init(groupID: groupID),
      child: Consumer<GroupTaskModel>(builder: (context, model, child) {
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
                        Scrollbar(
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemExtent: 80.0,
                            itemCount: model.notCompletedTasks.length + 1,
                            itemBuilder: (context, index) {
                              if (index < model.notCompletedTasks.length) {
                                final task = model.notCompletedTasks[index];
                                return GroupTaskListTile(
                                  taskTitle: task.title,
                                  dueDate: task.dueDate,
                                  isCompleted: task.isCompleted,
                                  assignedMembers: task.assignedMembers,
                                  memberImages: model.memberImages,
                                  checkboxCallback: (value) {
                                    model.toggleCheckState(task);
                                  },
                                  tileTappedCallback: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroupEditTaskScreen(
                                          groupID: groupID,
                                          task: task,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                    model.getTaskList(groupID: groupID);
                                  },
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                        Scrollbar(
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemExtent: 80.0,
                            itemCount: model.completedTasks.length + 1,
                            itemBuilder: (context, index) {
                              if (index < model.completedTasks.length) {
                                final task = model.completedTasks[index];
                                return GroupTaskListTile(
                                  taskTitle: task.title,
                                  dueDate: task.dueDate,
                                  isCompleted: task.isCompleted,
                                  assignedMembers: task.assignedMembers,
                                  memberImages: model.memberImages,
                                  checkboxCallback: (value) {
                                    model.toggleCheckState(task);
                                  },
                                  tileTappedCallback: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroupEditTaskScreen(
                                          groupID: groupID,
                                          task: task,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                    model.getTaskList(groupID: groupID);
                                  },
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
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
                  FlatButton(
                    onPressed: model.changeStateTasks.isEmpty
                        ? null
                        : () async {
                            model.startLoading();
                            await model.updateCheckState();
                            await model.getTaskList(groupID: groupID);
                            model.endLoading();
                          },
                    disabledTextColor: kTransparentPrimaryColor,
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
                ],
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AddFloatingActionButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GroupAddTaskScreen(groupID: groupID),
                          fullscreenDialog: true,
                        ),
                      );
                      model.getTaskList(groupID: groupID);
                    },
                  ),
                ],
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
