import 'package:beet/models/user_models/user_add_event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserAddEventScreen extends StatelessWidget {
  UserAddEventScreen({this.userID, this.dateTime});
  final userID;
  final dateTime;
  final dateFormat = DateFormat('y/M/d(E)    H:mm', 'ja_jp');
  final eventTitleController = TextEditingController();
  final eventPlaceController = TextEditingController();
  final eventMemoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserAddEventModel>(
      create: (_) => UserAddEventModel()..init(dateTime: dateTime),
      child: Consumer<UserAddEventModel>(builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('イベントを追加'),
                centerTitle: true,
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      '追加',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () async {
                      model.startLoading();
                      try {
                        await model.addEvent(userID: userID);
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
                        height: 50.0,
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
                          model.tileDateFormat.format(model.startingDateTime),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          model.showStartingDateTimePicker();
                        },
                      ),
                      model.startingDateTimePickerBox,
                      Divider(height: 0.5),
                      ListTile(
                        title: Text('終了'),
                        trailing: Text(
                          model.tileDateFormat.format(model.endingDateTime),
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          model.showEndingDateTimePicker();
                        },
                      ),
                      model.endingDateTimePickerBox,
                      TextField(
                        controller: eventMemoController,
                        maxLines: 3,
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
            Radius.circular(10.0),
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
