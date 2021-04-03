import 'package:beet/models/user_models/user_add_event_model.dart';
import 'package:beet/utilities/show_message_dialog.dart';
import 'package:beet/widgets/allday_switch_list_tile.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:beet/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserAddEventScreen extends StatelessWidget {
  final dateTime;
  final dateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_jp');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();
  final scrollController = ScrollController();

  UserAddEventScreen({this.dateTime});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserAddEventModel>(
      create: (_) => UserAddEventModel()..init(dateTime: dateTime),
      child: Consumer<UserAddEventModel>(builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(
              const Duration(milliseconds: 80),
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
                    title: const Text('イベントを追加'),
                    actions: [
                      TextButton(
                        child: const Text(
                          '追加',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.addEvent();
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: eventTitleController,
                              decoration: const InputDecoration(
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
                              decoration: const InputDecoration(
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
                              title: const Text('開始'),
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
                              title: const Text('終了'),
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
                                  decoration: const InputDecoration(
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
                                      const Duration(milliseconds: 100),
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
                            const SizedBox(height: 16.0),
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
