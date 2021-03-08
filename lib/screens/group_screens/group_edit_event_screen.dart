import 'package:beet/event.dart';
import 'package:beet/models/group_models/group_edit_event_model.dart';
import 'package:beet/widgets/basic_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupEditEventScreen extends StatelessWidget {
  GroupEditEventScreen({this.groupID, this.event});
  final String groupID;
  final Event event;
  final dateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_jp');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    eventTitleController.text = event.eventTitle;
    eventPlaceController.text = event.eventPlace;
    eventMemoController.text = event.eventMemo;
    return ChangeNotifierProvider<GroupEditEventModel>(
      create: (_) => GroupEditEventModel()..init(event: event),
      child: Consumer<GroupEditEventModel>(builder: (context, model, child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('イベントを編集'),
                  centerTitle: true,
                  actions: <Widget>[
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
                          await model.editEvent(groupID: groupID);
                          Navigator.pop(context);
                        } catch (e) {
                          _showTextDialog(context, e.toString());
                        }
                        model.endLoading();
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: eventTitleController,
                          decoration: InputDecoration(hintText: 'タイトル'),
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
                        TextField(
                          controller: eventPlaceController,
                          decoration: InputDecoration(hintText: '場所'),
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
                        SizedBox(
                          height: 30.0,
                        ),
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
                        TextField(
                          controller: eventMemoController,
                          maxLines: 10,
                          maxLength: 200,
                          decoration: InputDecoration(hintText: 'メモ'),
                          onTap: () {
                            if (model.isShowStartingPicker == true) {
                              model.showStartingDateTimePicker();
                            }
                            if (model.isShowEndingPicker == true) {
                              model.showEndingDateTimePicker();
                            }
                          },
                          onChanged: (text) {
                            model.eventMemo = text;
                          },
                        ),
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
        actions: <Widget>[
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
