import 'package:beet/models/user_models/user_edit_task_model.dart';
import 'package:beet/objects/task.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/assign_task_list_tile.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:beet/widgets/sized_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEditTaskScreen extends StatelessWidget {
  final Task task;
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskMemoController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  UserEditTaskScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    taskTitleController.text = task.title;
    taskMemoController.text = task.memo;
    return ChangeNotifierProvider<UserEditTaskModel>(
      create: (_) => UserEditTaskModel()..init(task: task),
      child: Consumer<UserEditTaskModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: SizedAppBar(
                  title: 'タスクを編集',
                  actions: [
                    TextButton(
                      child: const Text(
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
                          showMessageDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Scrollbar(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextField(
                              controller: taskTitleController,
                              decoration: const InputDecoration(
                                hintText: 'やること',
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                if (model.isShowDueDatePicker) {
                                  model.showDueDatePicker();
                                }
                              },
                              onChanged: (text) {
                                model.taskTitle = text;
                              },
                            ),
                            BasicDivider(),
                            ListTile(
                              title: const Text('いつまでに'),
                              trailing: Text(model.dueDateText),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                model.showDueDatePicker();
                              },
                            ),
                            model.dueDatePickerBox,
                            BasicDivider(),
                            Visibility(
                              // ユーザー個人のタスクの場合は表示しない
                              visible: model.ownerId != model.userId,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    'だれが',
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Container(
                                      height: 72,
                                      child: NotificationListener<ScrollNotification>(
                                        // これをtrueにしないと親のScrollbarも同時に動いてしまう
                                        onNotification: (_) => true,
                                        child: Scrollbar(
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics: const ScrollPhysics(),
                                            itemExtent: 60.0,
                                            itemCount: model.groupMembers.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              String userId = model.usersId[index];
                                              String userName = model.groupMembers[userId]!.name;
                                              String? userImageURL = model.groupMembers[userId]!.imageURL;
                                              return AssignTaskListTile(
                                                userName: userName,
                                                userImageURL: userImageURL,
                                                isChecked: model.assignedMembersId.contains(userId),
                                                tileTappedCallback: () {
                                                  model.assignPerson(userId: userId);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  BasicDivider(),
                                ],
                              ),
                            ),
                            NotificationListener<ScrollNotification>(
                              // これをtrueにしないと親のScrollbarも同時に動いてしまう
                              onNotification: (_) => true,
                              child: Scrollbar(
                                child: TextField(
                                  controller: taskMemoController,
                                  maxLines: 8,
                                  decoration: const InputDecoration(
                                    hintText: 'メモ',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0.0),
                                  ),
                                  onTap: () async {
                                    if (model.isShowDueDatePicker) {
                                      model.showDueDatePicker();
                                    }
                                    // 上手く動かないことがあるので少し待ってから
                                    // Columnの一番下までスクロールする
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );
                                    scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                  },
                                  onChanged: (text) {
                                    model.taskMemo = text;
                                  },
                                ),
                              ),
                            ),
                            BasicDivider(),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            LoadingIndicator(isLoading: model.isLoading),
          ],
        );
      }),
    );
  }
}
