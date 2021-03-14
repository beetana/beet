import 'package:beet/models/group_models/group_add_task_model.dart';
import 'package:beet/widgets/assign_task_list_tile.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupAddTaskScreen extends StatelessWidget {
  GroupAddTaskScreen({this.groupId});
  final String groupId;
  final taskTitleController = TextEditingController();
  final taskMemoController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAddTaskModel>(
      create: (_) => GroupAddTaskModel()..init(groupId: groupId),
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
                body: SafeArea(
                  child: Scrollbar(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              controller: taskTitleController,
                              decoration: InputDecoration(
                                hintText: 'やること',
                                border: InputBorder.none,
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
                            BasicDivider(),
                            ListTile(
                              title: Text('いつまでに'),
                              trailing: Text(model.dueDateText),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                model.showDueDatePicker();
                              },
                            ),
                            model.dueDatePickerBox,
                            BasicDivider(),
                            SizedBox(height: 8.0),
                            Text(
                              'だれが',
                              style: TextStyle(fontSize: 17.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                height: 72,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (_) => true,
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: ScrollPhysics(),
                                      itemExtent: 60.0,
                                      itemCount: model.userNames.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String userId = model.usersId[index];
                                        String userName =
                                            model.userNames[index];
                                        String userImageURL =
                                            model.userImageURLs[index];
                                        return AssignTaskListTile(
                                          userName: userName,
                                          userImageURL: userImageURL,
                                          isChecked: model.assignedMembersId
                                              .contains(userId),
                                          tileTappedCallback: () {
                                            model.assignPerson(userId);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BasicDivider(),
                            NotificationListener<ScrollNotification>(
                              onNotification: (_) => true,
                              child: Scrollbar(
                                child: TextField(
                                  controller: taskMemoController,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText: 'メモ',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0.0),
                                  ),
                                  onTap: () async {
                                    if (model.isShowDueDatePicker == true) {
                                      model.showDueDatePicker();
                                    }
                                    await Future.delayed(
                                      Duration(milliseconds: 100),
                                    );
                                    scrollController.jumpTo(scrollController
                                        .position.maxScrollExtent);
                                  },
                                  onChanged: (text) {
                                    model.taskMemo = text;
                                  },
                                ),
                              ),
                            ),
                            BasicDivider(),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
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
