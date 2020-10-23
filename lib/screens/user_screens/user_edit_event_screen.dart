import 'package:beet/event.dart';
import 'package:beet/models/user_models/user_edit_event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserEditEventScreen extends StatelessWidget {
  UserEditEventScreen({this.userID, this.event});
  final String userID;
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
    return ChangeNotifierProvider<UserEditEventModel>(
      create: (_) => UserEditEventModel()..init(event: event),
      child: Consumer<UserEditEventModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('イベントを編集'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      '完了',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      model.startLoading();
                      try {
                        await model.editEvent(userID: userID);
                        await _showTextDialog(context, '更新しました');
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
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: eventTitleController,
                      decoration: InputDecoration(hintText: 'タイトル'),
                      onChanged: (text) {
                        model.eventTitle = text;
                      },
                    ),
                    TextField(
                      controller: eventPlaceController,
                      decoration: InputDecoration(hintText: '場所'),
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
                    Divider(height: 0.5),
                    ListTile(
                      title: Text('開始'),
                      trailing: Text(
                          model.tileDateFormat.format(model.startingDateTime)),
                      onTap: () {
                        model.showStartingDateTimePicker();
                      },
                    ),
                    model.startingDateTimePickerBox,
                    Divider(height: 0.5),
                    ListTile(
                      title: Text('終了'),
                      trailing: Text(
                          model.tileDateFormat.format(model.endingDateTime)),
                      onTap: () {
                        model.showEndingDateTimePicker();
                      },
                    ),
                    model.endingDateTimePickerBox,
                    TextField(
                      controller: eventMemoController,
                      maxLines: 10,
                      maxLength: 200,
                      decoration: InputDecoration(hintText: 'メモ'),
                      onChanged: (text) {
                        model.eventMemo = text;
                      },
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
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
