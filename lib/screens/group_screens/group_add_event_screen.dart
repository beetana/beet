import 'package:beet/models/group_models/group_add_event_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/allday_switch_list_tile.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupAddEventScreen extends StatelessWidget {
  GroupAddEventScreen({this.groupId, this.dateTime});
  final groupId;
  final dateTime;
  final dateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_jp');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAddEventModel>(
      create: (_) => GroupAddEventModel()..init(dateTime: dateTime),
      child: Consumer<GroupAddEventModel>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(
              Duration(milliseconds: 80),
            );
            return true;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    title: Text('イベントを追加'),
                    actions: [
                      TextButton(
                        child: Text(
                          '追加',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.addEvent(groupId: groupId);
                            Navigator.pop(context);
                          } catch (e) {
                            showMessageDialog(context, e.toString());
                          }
                          model.endLoading();
                        },
                      ),
                    ],
                  ),
                  body: Scrollbar(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: eventTitleController,
                              decoration: InputDecoration(
                                hintText: 'タイトル',
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                if (model.isShowStartingPicker == true) {
                                  model.showStartingDateTimePicker();
                                }
                                if (model.isShowEndingPicker == true) {
                                  model.showEndingDateTimePicker();
                                }
                              },
                              onChanged: (text) {
                                model.eventTitle = text;
                              },
                            ),
                            BasicDivider(),
                            TextField(
                              controller: eventPlaceController,
                              decoration: InputDecoration(
                                hintText: '場所',
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                if (model.isShowStartingPicker == true) {
                                  model.showStartingDateTimePicker();
                                }
                                if (model.isShowEndingPicker == true) {
                                  model.showEndingDateTimePicker();
                                }
                              },
                              onChanged: (text) {
                                model.eventPlace = text;
                              },
                            ),
                            BasicDivider(),
                            AlldaySwitchListTile(
                              value: model.isAllDay,
                              onChanged: (value) {
                                model.switchIsAllDay(value);
                              },
                            ),
                            BasicDivider(),
                            ListTile(
                              title: Text('開始'),
                              trailing: Text(model.tileDateFormat
                                  .format(model.startingDateTime)),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                model.showStartingDateTimePicker();
                              },
                            ),
                            model.startingDateTimePickerBox,
                            BasicDivider(),
                            ListTile(
                              title: Text('終了'),
                              trailing: Text(model.tileDateFormat
                                  .format(model.endingDateTime)),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                model.showEndingDateTimePicker();
                              },
                            ),
                            model.endingDateTimePickerBox,
                            BasicDivider(),
                            NotificationListener<ScrollNotification>(
                              onNotification: (_) => true,
                              child: Scrollbar(
                                child: TextField(
                                  controller: eventMemoController,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText: 'メモ',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0.0),
                                  ),
                                  onTap: () async {
                                    if (model.isShowStartingPicker == true) {
                                      model.showStartingDateTimePicker();
                                    }
                                    if (model.isShowEndingPicker == true) {
                                      model.showEndingDateTimePicker();
                                    }
                                    await Future.delayed(
                                      Duration(milliseconds: 100),
                                    );
                                    scrollController.jumpTo(scrollController
                                        .position.maxScrollExtent);
                                  },
                                  onChanged: (text) {
                                    model.eventMemo = text;
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
                LoadingIndicator(isLoading: model.isLoading),
              ],
            ),
          ),
        );
      }),
    );
  }
}
