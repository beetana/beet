import 'package:beet/objects/event.dart';
import 'package:beet/models/user_models/user_edit_event_model.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserEditEventScreen extends StatelessWidget {
  UserEditEventScreen({this.userId, this.event});
  final String userId;
  final Event event;
  final dateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_jp');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    eventTitleController.text = event.title;
    eventPlaceController.text = event.place;
    eventMemoController.text = event.memo;
    return ChangeNotifierProvider<UserEditEventModel>(
      create: (_) => UserEditEventModel()..init(userId: userId, event: event),
      child: Consumer<UserEditEventModel>(builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text('イベントを編集'),
                  centerTitle: true,
                  actions: [
                    FlatButton(
                      child: Text(
                        '完了',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        model.startLoading();
                        try {
                          await model.updateEvent();
                          Navigator.pop(context);
                        } catch (e) {
                          _showTextDialog(context, e.toString());
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
                          SwitchListTile(
                            value: model.isAllDay,
                            title: Text('終日'),
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
              model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
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
